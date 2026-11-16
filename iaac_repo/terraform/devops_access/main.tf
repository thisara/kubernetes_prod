resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name      = "github-actions-oidc"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role" "github_eks_platform_deployer" {
  name = "github-eks-platform-deployer"
  path = "/terraform-managed/"

  assume_role_policy = data.aws_iam_policy_document.github_deployer_trust.json

  tags = {
    Name      = "github-eks-platform-deployer"
    ManagedBy = "Terraform"
    Purpose   = "EKS Platform Deployment"
  }
}

resource "aws_iam_role_policy" "github_eks_platform_deployer" {
  name = "github-eks-platform-deployer-policy"
  role = aws_iam_role.github_eks_platform_deployer.id

  policy = data.aws_iam_policy_document.github_eks_platform_deployer.json
}

resource "aws_eks_access_entry" "github_eks_platform_deployer" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.github_eks_platform_deployer.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_eks_platform_deployer" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.github_eks_platform_deployer.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.github_eks_platform_deployer
  ]
}
