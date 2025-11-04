terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "devops-86s-remote"
    key    = "devops-86s-${terraform.workspace}"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}


provider "aws" {
  # Configuration options
}