variable aws_region {
  description = AWS region
  type        = string
  default     = ap-south-1
}

variable project_name {
  description = Project name prefix
  type        = string
  default     = tutedude-separate-ec2
}

variable environment {
  description = Deployment environment
  type        = string
  default     = production
}

variable vpc_cidr {
  description = CIDR block for the custom VPC
  type        = string
  default     = 10.0.0.0/16
}

variable public_subnet_cidr {
  description = CIDR block for the public subnet
  type        = string
  default     = 10.0.1.0/24
}

variable instance_type {
  description = EC2 instance type
  type        = string
  default     = t2.micro
}

variable ami_id {
  description = Ubuntu 22.04 LTS AMI ID
  type        = string
  default     = ami-03f4878755434977f
}

variable admin_cidr {
  description = CIDR block for admin SSH access
  type        = string
  default     = 0.0.0.0/0
}
