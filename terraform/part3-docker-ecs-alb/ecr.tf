# ========================================================
# Terraform Part 3: AWS ECR Repositories (ecr.tf)
# ========================================================

resource aws_ecr_repository frontend_repo {
  name                 = -frontend
  image_tag_mutability = MUTABLE

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = -frontend-repo
    Environment = var.environment
  }
}

resource aws_ecr_repository backend_repo {
  name                 = -backend
  image_tag_mutability = MUTABLE

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = -backend-repo
    Environment = var.environment
  }
}
