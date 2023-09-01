terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60.0"
    }
  }

  backend "s3" {
    bucket = "tamas-gaspar-epam-cloudx-terraform-state"
    key = "AwsEksKubeDemo.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  # these credentials do not allow access: for that role must be assumed
  access_key = var.aws_key_id
  secret_key = var.aws_secret_key
  region = var.aws_region

  assume_role {
    role_arn = var.aws_terraform_role_arn
    external_id = var.aws_sts_external_id
    duration = "1h"
    session_name = "AwsEksKubeDemo-TerraformSession"
  }

  default_tags {
    tags = {
      application = "AwsEksKubeDemo"
      managed_by = "Terraform"
      repository = "https://github.com/Gtomika/aws-eks-kube-demo"
      owner = "Tamas Gaspar"
    }
  }
}