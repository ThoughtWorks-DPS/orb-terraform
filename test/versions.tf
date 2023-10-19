terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "twdps"
    workspaces {
      prefix = "psk-aws-platform-vpc-"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role}"
    session_name = "psk-aws-platform-vpc-${var.instance_name}"
  }

  default_tags {
    tags = {
      env                                          = var.instance_name
      cluster                                      = var.instance_name
      pipeline                                     = "psk-aws-platform-vpc"
      "kubernetes.io/cluster/${var.instance_name}" = "shared"
    }
  }
}