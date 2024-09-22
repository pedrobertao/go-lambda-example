terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }
    archive = {
      source = "hashicorp/archive"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      manage_by = "Terraform"
      app       = "go-get-my-ip"
    }
  }
}

