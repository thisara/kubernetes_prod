provider "aws" {
  region = var.aws_region
  dynamic "assume_role" {
    for_each = var.role_arn == null ? [] : [var.role_arn]
    content { role_arn = assume_role.value }
  }
}

data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
    exec = {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = concat(
        ["eks", "get-token", "--region", var.aws_region, "--cluster-name", var.cluster_name],
        var.role_arn == null ? [] : ["--role-arn", var.role_arn]
      )
    }
  }
}