# ========================================================
# Terraform Part 1: Single EC2 Deployment (main.tf)
# ========================================================

terraform {
  required_version = >= 1.5.0
  required_providers {
    aws = {
      source  = hashicorp/aws
      version = ~> 5.0
    }
  }
}

provider aws {
  region = var.aws_region
}

# Security Group for Single EC2
resource aws_security_group single_ec2_sg {
  name        = -single-ec2-sg
  description = Allow HTTP, SSH, and application ports

  ingress {
    description = HTTP Public Access
    from_port   = 80
    to_port     = 80
    protocol    = tcp
    cidr_blocks = [0.0.0.0/0]
  }

  ingress {
    description = SSH Admin Access
    from_port   = 22
    to_port     = 22
    protocol    = tcp
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = Express Frontend Port
    from_port   = 3000
    to_port     = 3000
    protocol    = tcp
    cidr_blocks = [0.0.0.0/0]
  }

  ingress {
    description = Flask Backend Port
    from_port   = 5000
    to_port     = 5000
    protocol    = tcp
    cidr_blocks = [0.0.0.0/0]
  }

  egress {
    description = Allow all outbound traffic
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [0.0.0.0/0]
  }

  tags = {
    Name        = -single-ec2-sg
    Environment = var.environment
  }
}

# Key Pair (Optional / Configurable)
resource aws_key_pair deployer_key {
  count      = var.public_key != " ? 1 : 0
 key_name = -key
 public_key = var.public_key
}

# Single EC2 Instance
resource aws_instance fullstack_app {
 ami = var.ami_id
 instance_type = var.instance_type
 vpc_security_group_ids = [aws_security_group.single_ec2_sg.id]
 key_name = var.public_key !=  ? aws_key_pair.deployer_key[0].key_name : null

 user_data = file(/scripts/user-data.sh)

 root_block_device {
 volume_size = 20
 volume_type = gp3
 }

 tags = {
 Name = -single-ec2
 Environment = var.environment
 }
}
