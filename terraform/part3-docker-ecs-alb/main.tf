terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Production S3 Remote State with DynamoDB State Locking (Configurable)
  backend "s3" {
    bucket         = "tutedude-terraform-state-prod-shubhajit"
    key            = "ecs-fargate/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tutedude-terraform-lock-prod"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
