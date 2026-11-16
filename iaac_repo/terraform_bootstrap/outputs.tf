output "terraform_role_arn" {
  description = "ARN of the Terraform production role"
  value       = aws_iam_role.terraform_prod.arn
}

output "terraform_eks_policy_arn" {
  description = "ARN of the Terraform EKS policy"
  value       = aws_iam_policy.eks.arn
}

output "terraform_network_policy_arn" {
  description = "ARN of the Terraform network policy"
  value       = aws_iam_policy.network.arn
}

output "terraform_s3_policy_arn" {
  description = "ARN of the Terraform S3 policy"
  value       = aws_iam_policy.s3.arn
}

output "terraform_iam_policy_arn" {
  description = "ARN of the Terraform IAM policy"
  value       = aws_iam_policy.iam.arn
}

output "terraform_cloudwatch_policy_arn" {
  description = "ARN of the Terraform CloudWatch policy"
  value       = aws_iam_policy.terraform_cloudwatch.arn
}

output "terraform_execution_policy_attachment_ids" {
  description = "Policy attachment IDs keyed by execution policy name"
  value       = { for name, attachment in aws_iam_role_policy_attachment.execution : name => attachment.id }
}

output "terraform_cloudwatch_policy_attachment_id" {
  description = "ID of the Terraform CloudWatch policy attachment"
  value       = aws_iam_role_policy_attachment.terraform_cloudwatch.id
}

output "terraform_assume_role_user_policy_id" {
  description = "ID of the bootstrap user assume-role policy"
  value       = aws_iam_user_policy.assume.id
}

