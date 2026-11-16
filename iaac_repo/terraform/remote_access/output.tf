output "eks_access_host_id" {
  description = "EC2 instance ID of the EKS management host"
  value       = aws_instance.eks_access_host.id
}

output "eks_access_host_private_ip" {
  description = "Private IP address of the EKS management host"
  value       = aws_instance.eks_access_host.private_ip
}

output "eks_access_host_role_arn" {
  description = "IAM role ARN used by the EKS management host"
  value       = aws_iam_role.eks_access_host.arn
}

output "eks_access_host_ami_id" {
  description = "Amazon Linux 2023 AMI ID used by the EKS management host"
  value       = var.eks_access_host_ami_id
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = var.cluster_name
}

output "tags" {
  description = "Tags for the EKS management host"
  value       = var.tags
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = var.eks_cluster_arn
}

output "file_api_vpc" {
  description = "File API VPC"
  value       = var.file_api_vpc
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = var.eks_cluster_security_group_id
}

output "aws_private_subnet_0" {
  description = "AWS private subnet for the EKS management host"
  value       = var.aws_private_subnet_0
}

output "private_rt_association" {
  description = "Private route table associations"
  value       = var.private_rt_association
}
