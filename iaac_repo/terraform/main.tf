data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "remote_access" {
    source = "./remote_access"

    github_runner_url = var.github_runner_url
    github_runner_token = var.github_runner_token

    cluster_name = var.cluster_name
    eks_cluster_arn = module.eks_cluster.eks_cluster_arn
    file_api_vpc = module.eks_cluster.vpc_id
    eks_cluster_security_group_id = module.eks_cluster.eks_cluster_security_group_id
    aws_private_subnet_0 = module.eks_cluster.private_subnet_ids[0]
    private_rt_association = module.eks_cluster.private_rt_association_ids
    eks_access_host_ami_id = data.aws_ami.al2023.id
    tags = var.tags

    depends_on = [
      module.eks_cluster,
      module.devops_access
    ]
}

module "eks_cluster" {
  source = "./eks_cluster"

  iam_assume_role = var.iam_assume_role
  bucket_name = var.bucket_name
  s3_iam_user = var.s3_iam_user
  aws_region = var.aws_region
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones = var.availability_zones
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  node_group_name = var.node_group_name
  node_instance_types = var.node_instance_types
  node_capacity_type = var.node_capacity_type
  node_min_size = var.node_min_size
  node_desired_size = var.node_desired_size
  node_max_size = var.node_max_size
  node_disk_size = var.node_disk_size
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access = var.endpoint_public_access
  cluster_log_retention_days = var.cluster_log_retention_days
  tags = var.tags
}

module "aws_resources" {
  source = "./aws_resources"
}

module "devops_access" {
  source = "./devops_access"

  github_org = var.github_org
  github_org_id  = var.github_org_id
  github_repo = var.github_repo
  github_repo_id = var.github_repo_id
  github_branch = var.github_branch
  
  cluster_name = module.eks_cluster.eks_cluster_name
  cluster_arn  = module.eks_cluster.eks_cluster_arn

  depends_on = [module.eks_cluster]
}
