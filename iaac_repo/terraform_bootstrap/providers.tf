terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "file-api-bootstrap-tf-state"
    key          = "bootstrap/prod/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = { 
      source = "hashicorp/aws" 
      version = "~> 5.0" 
    }
  }
}
provider "aws" { region = var.aws_region }