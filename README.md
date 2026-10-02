# Terraform Infrastructure as Code (IaC) - DevOps Assignment

**Student Name**: Shubhajit Paul  
**Course**: DevOps Masterclass (TuteDude)  
**Assignment**: Infrastructure Provisioning on AWS using Terraform  
**GitHub Repository Link**: [https://github.com/shubhajit-paul006/Tutedude.git](https://github.com/shubhajit-paul006/Tutedude.git)  

---

## 📌 Project Architecture & Deployment Modules

This project provisions AWS infrastructure using Terraform across three progressive configurations:

1. **Part 1: Single Amazon EC2 Instance** (`terraform/part1-single-ec2/`)
   - Provisions a single `t2.micro` instance running both Express (port 3000) and Flask (port 5000) reverse proxied via Nginx on Port 80.
2. **Part 2: Separate Amazon EC2 Instances** (`terraform/part2-separate-ec2/`)
   - Provisions custom VPC, public subnets, internet gateway, route tables, and two dedicated EC2 instances with restricted Security Groups.
3. **Part 3: Containerized AWS Deployment via ECR, ECS Fargate & ALB** (`terraform/part3-docker-ecs-alb/`)
   - Provisions two ECR repositories, multi-AZ VPC, ECS Fargate cluster, task definitions, auto-scaled services, Application Load Balancer with path-based routing, and S3 Remote State backend.

---

## 📂 Project Structure

```text
Terraform_ShubhajitPaul/
├── frontend/                     # Node.js Express source code & Dockerfile
│   ├── views/                    # EJS templates (index.ejs, success.ejs)
│   ├── public/                   # Static CSS stylesheet
│   ├── server.js                 # Express server & API client
│   ├── package.json              # Node dependencies & scripts
│   ├── Dockerfile                # Production Node.js 20 container image
│   └── .dockerignore
├── backend/                      # Python Flask REST API & Dockerfile
│   ├── app.py                    # Flask REST API endpoints
│   ├── data/data.json            # JSON storage
│   ├── requirements.txt          # Python dependencies (Flask, gunicorn, etc.)
│   ├── Dockerfile                # Production Python 3.11 container image
│   └── .dockerignore
├── terraform/
│   ├── part1-single-ec2/         # Single EC2 Terraform Module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars.example
│   │   └── scripts/user-data.sh
│   │
│   ├── part2-separate-ec2/       # Separate EC2 Instances & VPC Module
│   │   ├── main.tf
│   │   ├── vpc.tf
│   │   ├── security-groups.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars.example
│   │   └── scripts/
│   │       ├── backend-user-data.sh
│   │       └── frontend-user-data.sh
│   │
│   └── part3-docker-ecs-alb/     # Containerized ECS Fargate & ALB Module
│       ├── main.tf (S3 backend)
│       ├── ecr.tf
│       ├── vpc.tf
│       ├── alb.tf
│       ├── ecs.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars.example
│
├── .gitignore                    # Excludes .terraform, *.tfstate, .env, node_modules
├── README.md                     # Overview & Quickstart instructions
└── DOCUMENTATION.md              # Complete step-by-step submission documentation
```

---

## 🚀 How to Execute with Terraform

### 1. Initialize & Deploy Part 1 (Single EC2)
```bash
cd terraform/part1-single-ec2
terraform init
terraform plan
terraform apply -auto-approve
```

### 2. Initialize & Deploy Part 2 (Separate EC2 & VPC)
```bash
cd ../part2-separate-ec2
terraform init
terraform plan
terraform apply -auto-approve
```

### 3. Initialize & Deploy Part 3 (ECR, ECS Fargate & ALB)
```bash
cd ../part3-docker-ecs-alb
terraform init
terraform plan
terraform apply -auto-approve
```

### 4. Teardown / Destroy Infrastructure
```bash
terraform destroy -auto-approve
```
