variable aws_region {
 description = AWS region for deployment
 type = string
 default = ap-south-1
}

variable project_name {
 description = Project name prefix
 type = string
 default = tutedude-fullstack
}

variable environment {
 description = Environment name
 type = string
 default = production
}

variable instance_type {
 description = EC2 instance type
 type = string
 default = t2.micro
}

variable ami_id {
 description = Ubuntu 22.04 LTS AMI ID for ap-south-1
 type = string
 default = ami-03f4878755434977f
}

variable admin_cidr {
 description = CIDR block for SSH access
 type = string
 default = 0.0.0.0/0
}

variable public_key {
 description = Optional SSH public key string
 type = string
 default = 
}
