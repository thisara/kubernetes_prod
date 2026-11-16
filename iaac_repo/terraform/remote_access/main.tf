data "aws_region" "current" {}

# ---------------------------------------------------------
# IAM Role for EKS Access Host
# ---------------------------------------------------------

resource "aws_iam_role" "eks_access_host" {
  name = "${var.cluster_name}AccessHostRole"
  path = "/terraform-managed/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

# ---------------------------------------------------------
# Attach AWS Systems Manager Policy
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "eks_access_host_ssm" {
  role       = aws_iam_role.eks_access_host.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ---------------------------------------------------------
# IAM Policy for EKS Cluster Discovery
# ---------------------------------------------------------

resource "aws_iam_role_policy" "eks_access_host_eks" {
  name = "eks-describe-cluster"
  role = aws_iam_role.eks_access_host.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster"
        ]
        Resource = var.eks_cluster_arn
      }
    ]
  })
}

# ---------------------------------------------------------
# IAM Instance Profile
# ---------------------------------------------------------

resource "aws_iam_instance_profile" "eks_access_host" {
  name = "${var.cluster_name}-access-host"
  path = "/terraform-managed/"
  role = aws_iam_role.eks_access_host.name
}

# ---------------------------------------------------------
# Security Group for EKS Access Host
# ---------------------------------------------------------

resource "aws_security_group" "eks_access_host" {
  name        = "${var.cluster_name}-access-host"
  description = "Private EKS management host accessed through SSM"
  vpc_id      = var.file_api_vpc

  # No inbound rules required.
  # Access is provided through AWS SSM Session Manager.

  egress {
    description = "HTTPS to EKS, SSM, and tool repositories"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# ---------------------------------------------------------
# Allow Access Host to Connect to Private EKS API
# ---------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "eks_from_access_host" {
  security_group_id = var.eks_cluster_security_group_id

  description                  = "Private EKS API access from management host"
  referenced_security_group_id = aws_security_group.eks_access_host.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# ---------------------------------------------------------
# EKS Access Entry for EC2 Management Host
# ---------------------------------------------------------

resource "aws_eks_access_entry" "eks_access_host" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.eks_access_host.arn
  type          = "STANDARD"

  tags = var.tags
}

# ---------------------------------------------------------
# EKS Access Policy Association
# Grants Cluster Administrator Permissions
# ---------------------------------------------------------

resource "aws_eks_access_policy_association" "eks_access_host" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.eks_access_host.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.eks_access_host
  ]
}

# ---------------------------------------------------------
# EC2 Management Host
# ---------------------------------------------------------

resource "aws_instance" "eks_access_host" {
  ami                         = var.eks_access_host_ami_id
  instance_type               = "t3.small"
  subnet_id                   = var.aws_private_subnet_0
  associate_public_ip_address = false

  iam_instance_profile   = aws_iam_instance_profile.eks_access_host.name
  vpc_security_group_ids = [aws_security_group.eks_access_host.id]

  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail

    work_dir=$(mktemp -d)
    trap 'rm -rf "$work_dir"' EXIT
    cd "$work_dir"

    # Install system dependencies
    dnf install -y \
      unzip \
      glibc \
      libgcc \
      ca-certificates \
      openssl-libs \
      libstdc++ \
      libicu \
      tzdata \
      krb5-libs \
      zlib

    # Install AWS CLI v2
    curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
      -o awscliv2.zip
    unzip -q awscliv2.zip
    ./aws/install --update
    export PATH="/usr/local/bin:$PATH"

    # Install Terraform
    curl -fsSL https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo \
      -o /etc/yum.repos.d/hashicorp.repo
    dnf install -y terraform

    # Retrieve EKS cluster version
    cluster_version=$(aws eks describe-cluster \
      --name '${var.cluster_name}' \
      --region '${data.aws_region.current.region}' \
      --query 'cluster.version' --output text)

    # Install matching kubectl version
    kubectl_version=$(curl -fsSL "https://dl.k8s.io/release/stable-$${cluster_version}.txt")

    curl -fsSLO "https://dl.k8s.io/release/$${kubectl_version}/bin/linux/amd64/kubectl"
    curl -fsSLO "https://dl.k8s.io/release/$${kubectl_version}/bin/linux/amd64/kubectl.sha256"

    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    install -m 0755 kubectl /usr/local/bin/kubectl

    # Install Helm
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
      -o get-helm-3
    bash get-helm-3

    # Install .NET 10 SDK
    dnf install -y dotnet-sdk-10.0

    # Install ASP.NET Core 10 Runtime
    dnf install -y aspnetcore-runtime-10.0

    # Verify installations
    aws --version
    terraform version
    kubectl version --client
    helm version
    dotnet --info
    dotnet --list-sdks
    dotnet --list-runtimes

    echo "EC2 bootstrap completed successfully."
  EOF

  # Enforce IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Encrypted EBS Root Volume
  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-access-host"
  })

  depends_on = [
    var.private_rt_association,
    aws_iam_role_policy_attachment.eks_access_host_ssm,
    aws_iam_role_policy.eks_access_host_eks,
    aws_eks_access_policy_association.eks_access_host
  ]
}
