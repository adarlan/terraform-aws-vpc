terraform {

  backend "s3" {
    region = var.tf_backend_s3.region
    bucket = var.tf_backend_s3.bucket
    key    = var.tf_backend_s3.key
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
