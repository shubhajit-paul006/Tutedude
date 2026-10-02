# ========================================================
# Terraform Part 3: Multi-AZ VPC (vpc.tf)
# ========================================================

resource aws_vpc ecs_vpc {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = -vpc
    Environment = var.environment
  }
}

resource aws_internet_gateway ecs_igw {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = -igw
  }
}

resource aws_subnet public_subnet_1 {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = a
  map_public_ip_on_launch = true

  tags = {
    Name = -public-1a
  }
}

resource aws_subnet public_subnet_2 {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = b
  map_public_ip_on_launch = true

  tags = {
    Name = -public-1b
  }
}

resource aws_route_table public_rt {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = 0.0.0.0/0
    gateway_id = aws_internet_gateway.ecs_igw.id
  }

  tags = {
    Name = -public-rt
  }
}

resource aws_route_table_association public_assoc_1 {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource aws_route_table_association public_assoc_2 {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}
