# We here locked the providers and terraform versions.
terraform {
  required_version = ">= 0.15" # required version for terraform
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.28"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.0"
    }
    cloudinit = {
        source = "hashicorp/cloudinit"
        version = "~> 2.1"
    }
  }
}