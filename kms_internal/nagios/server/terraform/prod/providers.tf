terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket               = "terraform-bucket"
    dynamodb_table       = "terraform_state"
    key                  = "terraform.tfstate"
    region               = "us-east-1"
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region = var.region
}