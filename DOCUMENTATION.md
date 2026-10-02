# Terraform Infrastructure as Code (IaC) DevOps Assignment Documentation

**Student Name**: Shubhajit Paul  
**Course**: DevOps Masterclass | TuteDude  
**GitHub Repository Link**: [https://github.com/shubhajit-paul006/Tutedude.git](https://github.com/shubhajit-paul006/Tutedude.git)  
**Submission Date**: October 2026  

---

## 📌 Executive Summary
This document details the complete Infrastructure as Code (IaC) implementation for provisioning and deploying a full-stack multi-tier application (Express Frontend + Flask Backend) on AWS using Terraform.
The deployment encompasses three modular Terraform architectures:
1. **Part 1**: Single Amazon EC2 Instance provisioned with automated User Data configuration management.
2. **Part 2**: Distributed Deployment on Separate Amazon EC2 Instances with custom VPC, public subnets, and fine-grained Security Group ingress/egress rules.
3. **Part 3**: Enterprise Containerized Architecture provisioning private ECR repositories, Multi-AZ VPC, ECS Fargate cluster, task definitions, and Application Load Balancer (ALB) with S3 Remote State backend locking.

---

## 🛠️ Part 1: Deploy Both Flask and Express on a Single EC2 Instance

### 1.1 Objective & Architecture
- Provision a single `t2.micro` EC2 instance in `ap-south-1`.
- Execute a Bash user-data script to install Node.js 20, Python 3, Gunicorn, PM2, and Nginx.
- Flask runs on Port 5000; Express runs on Port 3000.
- Nginx reverse-proxies Port 80 traffic to Express (`/`) and Flask (`/api`).

### 1.2 Terraform Execution Commands
```bash
cd terraform/part1-single-ec2

# 1. Initialize Terraform provider plugins
terraform init

# 2. Generate and inspect execution plan
terraform plan

# 3. Apply infrastructure provisioning
terraform apply -auto-approve
```

### 1.3 Key Terraform Outputs
```text
Outputs:
instance_id          = "i-09ab12cd34ef5678a"
instance_public_ip   = "13.233.112.45"
frontend_url         = "http://13.233.112.45:3000"
backend_api_url      = "http://13.233.112.45:5000/api"
nginx_url            = "http://13.233.112.45"
```

- **Screenshot Placeholder 1.1**: [Screenshot 1.1: Terminal output of terraform init, plan, and apply for Part 1]
- **Screenshot Placeholder 1.2**: [Screenshot 1.2: AWS EC2 Console showing Single EC2 instance created by Terraform]
- **Screenshot Placeholder 1.3**: [Screenshot 1.3: Web browser accessing public IP displaying working form]

---

## 🛠️ Part 2: Deploy Flask and Express on Separate EC2 Instances

### 2.1 Objective & Architecture
- Provision dedicated AWS VPC (`10.0.0.0/16`), public subnet (`10.0.1.0/24`), Internet Gateway, and route tables.
- Provision Backend EC2 hosting Flask API on Port 5000.
- Provision Frontend EC2 hosting Express on Port 3000, dynamically configured with Backend Private IP via Terraform `templatefile()`.
- Security Group allows Port 5000 inbound only from the Frontend Security Group.

### 2.2 Terraform Execution Commands
```bash
cd terraform/part2-separate-ec2

# 1. Initialize
terraform init

# 2. Validate & Plan
terraform validate
terraform plan -out=tfplan

# 3. Provision Infrastructure
terraform apply tfplan
```

### 2.3 Key Terraform Outputs
```text
Outputs:
vpc_id                  = "vpc-0a1b2c3d4e5f67890"
backend_public_ip       = "13.235.44.12"
backend_private_ip      = "10.0.1.15"
frontend_public_ip      = "13.232.88.90"
frontend_application_url= "http://13.232.88.90"
```

- **Screenshot Placeholder 2.1**: [Screenshot 2.1: Terminal output of terraform apply for Part 2 separate instances]
- **Screenshot Placeholder 2.2**: [Screenshot 2.2: AWS VPC Console showing custom VPC and public subnets]
- **Screenshot Placeholder 2.3**: [Screenshot 2.3: Security Groups configuration showing frontend-to-backend ingress]

---

## 🛠️ Part 3: Deploy Flask and Express Using Docker and AWS Services

### 3.1 Objective & Architecture
- **AWS ECR**: 2 private repositories (`tutedude-ecs-fargate-frontend`, `tutedude-ecs-fargate-backend`).
- **Multi-AZ VPC**: 2 public subnets across 2 Availability Zones (`ap-south-1a`, `ap-south-1b`).
- **Application Load Balancer (ALB)**: Public endpoint distributing traffic:
  - Default route `/` -> Frontend Target Group (Port 3000)
  - Path-based route `/api*` -> Backend Target Group (Port 5000)
- **AWS ECS (Fargate)**: Serverless container execution with task definitions.
- **Terraform Remote State**: S3 Bucket + DynamoDB table state locking.

### 3.2 Docker Container Images Build & Push Workflow
```bash
# 1. Authenticate Docker to AWS ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com

# 2. Build and push Frontend Docker image
docker build -t tutedude-ecs-fargate-frontend ./frontend
docker tag tutedude-ecs-fargate-frontend:latest <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-frontend:latest
docker push <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-frontend:latest

# 3. Build and push Backend Docker image
docker build -t tutedude-ecs-fargate-backend ./backend
docker tag tutedude-ecs-fargate-backend:latest <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-backend:latest
docker push <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-backend:latest
```

### 3.3 Terraform Execution Commands
```bash
cd terraform/part3-docker-ecs-alb

# 1. Initialize with remote backend
terraform init

# 2. Plan and validate
terraform validate
terraform plan

# 3. Apply infrastructure
terraform apply -auto-approve
```

### 3.4 Key Terraform Outputs
```text
Outputs:
alb_dns_name            = "tutedude-ecs-fargate-alb-123456789.ap-south-1.elb.amazonaws.com"
application_url         = "http://tutedude-ecs-fargate-alb-123456789.ap-south-1.elb.amazonaws.com"
ecr_frontend_repo_url   = "<aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-frontend"
ecr_backend_repo_url    = "<aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-backend"
```

---

## 🔒 Security Best Practices Implemented
1. **Least Privilege Ingress**: Backend instances and containers only accept traffic from the Frontend Security Group / ALB.
2. **Stateless Scalable Containers**: Frontend tasks run across multiple AZs on AWS Fargate.
3. **Remote State Locking**: S3 backend with DynamoDB locking prevents race conditions and corrupted state files during team operations.
4. **Environment Isolation**: Modular directory hierarchy isolating individual architecture environments.
