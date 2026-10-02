terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Key Pair
resource "aws_key_pair" "auth_key" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key_openssh
}

# Backend EC2 Instance
resource "aws_instance" "backend_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.auth_key.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  user_data                   = file("${path.module}/scripts/backend-user-data.sh")
  user_data_replace_on_change = true

  tags = {
    Name        = "${var.project_name}-backend"
    Environment = var.environment
    Tier        = "Backend"
  }
}

# Frontend EC2 Instance
resource "aws_instance" "frontend_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.auth_key.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  user_data = templatefile("${path.module}/scripts/frontend-user-data.sh", {
    backend_ip = aws_instance.backend_instance.private_ip
  })
  user_data_replace_on_change = true

  depends_on = [aws_instance.backend_instance]

  tags = {
    Name        = "${var.project_name}-frontend"
    Environment = var.environment
    Tier        = "Frontend"
  }
}
