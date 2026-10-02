# ========================================================
# Terraform Part 2: Security Groups (security-groups.tf)
# ========================================================

# Frontend Security Group
resource aws_security_group frontend_sg {
  name        = -frontend-sg
  description = Public access to Express frontend and SSH
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = HTTP Web Access
    from_port   = 80
    to_port     = 80
    protocol    = tcp
    cidr_blocks = [0.0.0.0/0]
  }

  ingress {
    description = NodePort / Custom Port 3000
    from_port   = 3000
    to_port     = 3000
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [0.0.0.0/0]
  }

  tags = {
    Name        = -frontend-sg
    Environment = var.environment
  }
}

# Backend Security Group (Restricted communication)
resource aws_security_group backend_sg {
  name        = -backend-sg
  description = Allow port 5000 from frontend security group and SSH
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description     = Flask API from Frontend SG
    from_port       = 5000
    to_port         = 5000
    protocol        = tcp
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
    description = Flask API direct testing (optional)
    from_port   = 5000
    to_port     = 5000
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [0.0.0.0/0]
  }

  tags = {
    Name        = -backend-sg
    Environment = var.environment
  }
}
