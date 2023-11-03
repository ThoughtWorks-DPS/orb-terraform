terraform {
  required_version = "~> 1.6"
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
      prefix = "orb-terraform-"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      env                                          = var.instance_name
      cluster                                      = var.instance_name
      pipeline                                     = "orb-terraform"
    }
  }
}