terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      env                                          = var.instance_name
      cluster                                      = var.instance_name
      pipeline                                     = "psk-aws-platform-vpc"
    }
  }
}