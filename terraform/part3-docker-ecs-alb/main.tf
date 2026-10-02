# ========================================================
# Terraform Part 3: Main Provider & S3 Remote State (main.tf & backend.tf)
# ========================================================

terraform {
  required_version = >= 1.5.0
  required_providers {
    aws = {
      source  = hashicorp/aws
      version = ~> 5.0
    }
  }

  # S3 Remote State & DynamoDB Locking
  backend s3 {
    bucket         = tutedude-devops-terraform-state-2026
    key            = ecs-docker/terraform.tfstate
    region         = ap-south-1
    dynamodb_table = terraform-lock-table
    encrypt        = true
  }
}

provider aws {
  region = var.aws_region
}
