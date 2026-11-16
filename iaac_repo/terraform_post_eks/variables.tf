variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "cluster_name" {
  type    = string
  default = "file-api-eks"
}
variable "role_arn" {
  description = "Optional IAM role to assume for both AWS discovery and Helm EKS authentication."
  type        = string
  default     = null
}
variable "argocd_chart_version" {
  description = "Pin a tested argo-cd Helm chart version (not the Argo CD app version)."
  type        = string
}
variable "namespace" {
  type    = string
  default = "argocd"
}

variable "istio_chart_version" {
  description = "Exact tested Istio chart version for base and istiod."
  type        = string
}
