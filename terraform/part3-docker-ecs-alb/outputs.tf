output ecr_frontend_repo_url {
  description = ECR Repository URL for Frontend Image
  value       = aws_ecr_repository.frontend_repo.repository_url
}

output ecr_backend_repo_url {
  description = ECR Repository URL for Backend Image
  value       = aws_ecr_repository.backend_repo.repository_url
}

output alb_dns_name {
  description = Public DNS name of Application Load Balancer
  value       = aws_lb.main_alb.dns_name
}

output application_url {
  description = Public URL to access the containerized application
  value       = http://
}
