#GHA DEV OPS
variable "github_org" {
  description = "GitHub organisation or username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_org_id" {
  description = "GitHub repository owner ID"
  type        = string
}

variable "github_repo_id" {
  description = "GitHub repository ID"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch permitted to deploy"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the EKS cluster"
  type        = string
}