terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-bucket"
    dynamodb_table = "terraform_state"
    key            = "terraform.tfstate"
    region         = "us-east-1"

  #   # For development purposes
  #   endpoint                    = "http://localhost:4566"
  #   dynamodb_endpoint           = "http://localhost:4566"
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   force_path_style            = true
  #   encrypt                     = true
  }
  required_version = "~> 1.6.0"
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  # For development purposes
  # s3_use_path_style           = true
  # skip_credentials_validation = true
  # skip_metadata_api_check     = true
  # skip_requesting_account_id  = true

  # endpoints {
  #   apigateway     = "http://localhost:4566"
  #   apigatewayv2   = "http://localhost:4566"
  #   cloudformation = "http://localhost:4566"
  #   cloudwatch     = "http://localhost:4566"
  #   dynamodb       = "http://localhost:4566"
  #   ec2            = "http://localhost:4566"
  #   es             = "http://localhost:4566"
  #   elasticache    = "http://localhost:4566"
  #   firehose       = "http://localhost:4566"
  #   iam            = "http://localhost:4566"
  #   kinesis        = "http://localhost:4566"
  #   lambda         = "http://localhost:4566"
  #   rds            = "http://localhost:4566"
  #   redshift       = "http://localhost:4566"
  #   route53        = "http://localhost:4566"
  #   s3             = "http://s3.localhost.localstack.cloud:4566"
  #   secretsmanager = "http://localhost:4566"
  #   ses            = "http://localhost:4566"
  #   sns            = "http://localhost:4566"
  #   sqs            = "http://localhost:4566"
  #   ssm            = "http://localhost:4566"
  #   stepfunctions  = "http://localhost:4566"
  #   sts            = "http://localhost:4566"
  # }
}