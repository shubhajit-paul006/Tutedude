output vpc_id {
  description = VPC ID
  value       = aws_vpc.custom_vpc.id
}

output backend_public_ip {
  description = Public IP of Backend EC2
  value       = aws_instance.backend_instance.public_ip
}

output backend_private_ip {
  description = Private IP of Backend EC2
  value       = aws_instance.backend_instance.private_ip
}

output frontend_public_ip {
  description = Public IP of Frontend EC2
  value       = aws_instance.frontend_instance.public_ip
}

output frontend_application_url {
  description = URL to access Frontend web application
  value       = http://:3000
}

output backend_api_url {
  description = URL to access Backend API directly
  value       = http://:5000/api
}
