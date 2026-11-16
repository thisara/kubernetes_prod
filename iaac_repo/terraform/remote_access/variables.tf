variable "github_runner_url" {
  description = "GitHub repository or organization URL for the self-hosted runner."
  type        = string
}

variable "github_runner_token" {
  description = "Fresh GitHub runner registration token from terraform.tfvars."
  type        = string
  sensitive   = true

  validation {
    condition     = length(trimspace(var.github_runner_token)) > 0
    error_message = "Set github_runner_token in terraform.tfvars before applying."
  }
}

variable "eks_access_host_ami_id" {
  description = "Amazon Linux 2023 x86_64 AMI ID with SSM Agent installed."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tag for access host"
  type        = map(string)
  default     = {}
}

variable "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  type        = string
}

variable "file_api_vpc" {
  description = "File API VPC"
  type        = string
}

variable "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  type        = string
}

variable "aws_private_subnet_0" {
  description = "AWS private subnet for management host"
  type        = string
}

variable "private_rt_association" {
  description = "Private route table association"
  type        = list(string)
}
