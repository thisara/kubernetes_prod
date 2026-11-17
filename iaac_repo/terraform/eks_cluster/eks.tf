#data "aws_subnet" "private_subnets" {
#  for_each = toset(aws_subnet.private_subnets)
#
#  id = each.value
#}

#locals {
#  private_subnet_azs = [
#    for subnet in data.aws_subnet.private_subnets :
#    subnet.availability_zone
#  ]
#}

#--EKS_CLOUDWATCH

resource "aws_cloudwatch_log_group" "eks_cluster" {
  name = "/aws/eks/${var.cluster_name}/cluster"

  retention_in_days = var.cluster_log_retention_days

  tags = var.tags
}

#--EKS_CLUSTER

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_config {
    subnet_ids = [
      for subnet in aws_subnet.private_subnets : subnet.id
    ]

    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  access_config {
    authentication_mode = "API"

    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition = alltrue([
        for subnet in aws_subnet.private_subnets :
        subnet.vpc_id == aws_vpc.file_api_vpc.id
      ])

      error_message = "All EKS subnets must belong to the specified VPC."
    }

    precondition {
      condition = length(var.availability_zones) == 2

      error_message = "EKS subnets must be in two different Availability Zones."
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_cloudwatch_log_group.eks_cluster,
    aws_subnet.private_subnets
  ]
}

#--MANAGED_NODE_GROUP

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    for subnet in aws_subnet.private_subnets : subnet.id
  ]

  instance_types = var.node_instance_types
  capacity_type  = var.node_capacity_type

  disk_size = var.node_disk_size

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    precondition {
      condition = (
        var.node_min_size <= var.node_desired_size &&
        var.node_desired_size <= var.node_max_size
      )

      error_message = "Node scaling must satisfy min <= desired <= max."
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-managed-node"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
    aws_eks_addon.vpc_cni,
    aws_eks_addon.kube_proxy
  ]
}

#--POD IDENTITY AGENT

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "eks-pod-identity-agent"

  resolve_conflicts_on_update = "PRESERVE"

  tags = var.tags
}

#Application use boto3 to directly connec to seret store. instead it should read secrets in ns
resource "aws_eks_pod_identity_association" "file_api" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "file-api"
  service_account = "file-api"
  role_arn        = aws_iam_role.file_api_pod_role.arn
}

resource "aws_eks_pod_identity_association" "eso" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.file_api_pod_role.arn
}

#--VPC CNI

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"

  resolve_conflicts_on_update = "PRESERVE"

  pod_identity_association {
    service_account = "aws-node"
    role_arn        = aws_iam_role.eks_vpc_cni_role.arn
  }

  tags = var.tags

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.eks_vpc_cni_policy
  ]
}

#--CORE DNS

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"

  resolve_conflicts_on_update = "PRESERVE"

  configuration_values = jsonencode({
    replicaCount = 2
  })

  depends_on = [
    aws_eks_node_group.private_nodes
  ]

  tags = var.tags
}

#--KUBE PROXY

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"

  resolve_conflicts_on_update = "PRESERVE"

  tags = var.tags
}

#--Metrix Server

resource "aws_eks_addon" "metrics_server" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "metrics-server"

  depends_on = [
    aws_eks_node_group.private_nodes
  ]

  tags = var.tags
}
