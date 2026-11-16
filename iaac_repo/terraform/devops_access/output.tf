output "github_eks_platform_deployer_role" {
  description = "IAM role used by GitHub to deploy the EKS platform"
  value       = aws_iam_role.github_eks_platform_deployer
}

output "github_eks_platform_deployer_role_policy" {
  description = "Inline IAM policy for the GitHub EKS platform deployer role"
  value       = aws_iam_role_policy.github_eks_platform_deployer
}
