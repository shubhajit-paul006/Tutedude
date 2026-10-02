# ========================================================
# Terraform Part 2: Separate EC2 Instances (vpc.tf)
# ========================================================

resource aws_vpc custom_vpc {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = -vpc
    Environment = var.environment
  }
}

resource aws_internet_gateway igw {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name        = -igw
    Environment = var.environment
  }
}

resource aws_subnet public_subnet {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = a
  map_public_ip_on_launch = true

  tags = {
    Name        = -public-subnet
    Environment = var.environment
  }
}

resource aws_route_table public_rt {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = 0.0.0.0/0
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = -public-rt
    Environment = var.environment
  }
}

resource aws_route_table_association public_assoc {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
