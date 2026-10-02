# ========================================================
# Terraform Part 2: EC2 Instances (main.tf)
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

# 1. Backend EC2 Instance (Flask)
resource aws_instance backend_instance {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  user_data = file(/scripts/backend-user-data.sh)

  root_block_device {
    volume_size = 20
    volume_type = gp3
  }

  tags = {
    Name        = -backend-ec2
    Environment = var.environment
  }
}

# 2. Frontend EC2 Instance (Express)
resource aws_instance frontend_instance {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  user_data = templatefile(/scripts/frontend-user-data.sh, {
    backend_ip = aws_instance.backend_instance.private_ip
  })

  depends_on = [aws_instance.backend_instance]

  root_block_device {
    volume_size = 20
    volume_type = gp3
  }

  tags = {
    Name        = -frontend-ec2
    Environment = var.environment
  }
}
