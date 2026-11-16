variable "aws_region" { 
    type = string
    default = "ap-southeast-2" 
}

variable "account_id" { 
    type = string 
}

variable "bootstrap_user" { 
    type = string
    default = "infra_user" 
}

variable "role_name" { 
    type = string
    default = "terraformProdRole" 
}

variable "resource_prefix" { 
    type = string
    default = "file-api-" 
}
