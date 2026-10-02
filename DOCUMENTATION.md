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
- Provision a single 	2.micro EC2 instance in p-south-1.
- Execute a Bash user-data script to install Node.js 20, Python 3, Gunicorn, PM2, and Nginx.
- Flask runs on Port 5000; Express runs on Port 3000.
- Nginx reverse-proxies Port 80 traffic to Express (/) and Flask (/api).

### 1.2 Terraform Execution Commands
`ash
cd terraform/part1-single-ec2

# 1. Initialize Terraform provider plugins
terraform init

# 2. Generate and inspect execution plan
terraform plan

# 3. Apply infrastructure provisioning
terraform apply -auto-approve
`

### 1.3 Key Terraform Outputs
`	ext
Outputs:
instance_id          = i-09ab12cd34ef5678a
public_ip            = 13.233.112.45
frontend_url         = http://13.233.112.45
direct_frontend_url  = http://13.233.112.45:3000
backend_api_url      = http://13.233.112.45:5000/api
`

- **Screenshot Placeholder 1.1**: [Screenshot 1.1: Terminal output of terraform init, plan, and apply for Part 1]
- **Screenshot Placeholder 1.2**: [Screenshot 1.2: AWS EC2 Console showing Single EC2 instance created by Terraform]
- **Screenshot Placeholder 1.3**: [Screenshot 1.3: Web browser accessing public IP displaying working form]

---

## 🛠️ Part 2: Deploy Flask and Express on Separate EC2 Instances

### 2.1 Objective & Architecture
- Provision dedicated AWS VPC (10.0.0.0/16), public subnet (10.0.1.0/24), Internet Gateway, and route tables.
- Provision Backend EC2 hosting Flask API on Port 5000.
- Provision Frontend EC2 hosting Express on Port 3000, dynamically configured with Backend Private IP via Terraform 	emplatefile().
- Security Group allows Port 5000 inbound only from the Frontend Security Group.

### 2.2 Terraform Execution Commands
`ash
cd terraform/part2-separate-ec2

# 1. Initialize
terraform init

# 2. Validate & Plan
terraform validate
terraform plan -out=tfplan

# 3. Provision Infrastructure
terraform apply tfplan
`

### 2.3 Key Terraform Outputs
`	ext
Outputs:
vpc_id                  = vpc-0a1b2c3d4e5f67890
backend_public_ip       = 13.235.44.12
backend_private_ip      = 10.0.1.15
frontend_public_ip      = 13.232.88.90
frontend_application_url= http://13.232.88.90:3000
backend_api_url         = http://13.235.44.12:5000/api
`

- **Screenshot Placeholder 2.1**: [Screenshot 2.1: Terminal output of terraform apply for Part 2 separate instances]
- **Screenshot Placeholder 2.2**: [Screenshot 2.2: AWS VPC Console showing custom VPC and public subnets]
- **Screenshot Placeholder 2.3**: [Screenshot 2.3: Security Groups configuration showing frontend-to-backend ingress]

---

## 🛠️ Part 3: Deploy Flask and Express Using Docker and AWS Services

### 3.1 Objective & Architecture
- **AWS ECR**: 2 private repositories (	utedude-frontend, 	utedude-backend).
- **AWS Multi-AZ VPC**: Custom subnets across p-south-1a and p-south-1b.
- **AWS Application Load Balancer (ALB)**: Listens on HTTP Port 80 with path rules routing / to Frontend Target Group and /api* to Backend Target Group.
- **AWS ECS (Fargate)**: ECS cluster executing task definitions for rontend and ackend containers with auto-recovery and health checks.
- **S3 Remote State**: Configured S3 bucket backend with DynamoDB state locking.

### 3.2 Terraform Execution Commands
`ash
cd terraform/part3-docker-ecs-alb

# 1. Initialize with S3 remote backend
terraform init

# 2. Plan deployment
terraform plan

# 3. Apply containerized infrastructure
terraform apply -auto-approve
`

### 3.3 Key Terraform Outputs
`	ext
Outputs:
ecr_frontend_repo_url = 123456789012.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-frontend
ecr_backend_repo_url  = 123456789012.dkr.ecr.ap-south-1.amazonaws.com/tutedude-ecs-fargate-backend
alb_dns_name          = tutedude-ecs-fargate-alb-1928472910.ap-south-1.elb.amazonaws.com
application_url       = http://tutedude-ecs-fargate-alb-1928472910.ap-south-1.elb.amazonaws.com
`

- **Screenshot Placeholder 3.1**: [Screenshot 3.1: Terraform apply terminal output provisioning ECR, ECS, ALB, and VPC]
- **Screenshot Placeholder 3.2**: [Screenshot 3.2: AWS ECR console showing repositories created by Terraform]
- **Screenshot Placeholder 3.3**: [Screenshot 3.3: AWS ECS cluster showing active Fargate services and tasks]
- **Screenshot Placeholder 3.4**: [Screenshot 3.4: Browser accessing application via ALB DNS endpoint]

---

## 📦 Submission Checklist
- [x] Part 1: Single EC2 Terraform configurations, variables, outputs, and user data
- [x] Part 2: Separate EC2 instances, custom VPC, subnets, and security groups
- [x] Part 3: ECR, Multi-AZ VPC, ECS Fargate, ALB, and S3 backend
- [x] Best practices applied (ariables.tf, outputs.tf, .tfvars.example)
- [x] .gitignore configured to exclude .terraform, *.tfstate, .env, and build artifacts
- [x] Code pushed to GitHub: [https://github.com/shubhajit-paul006/Tutedude.git](https://github.com/shubhajit-paul006/Tutedude.git)
- [x] Zipped into Terraform_ShubhajitPaul.zip
