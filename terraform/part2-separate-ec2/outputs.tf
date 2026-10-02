output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.custom_vpc.id
}

output "frontend_public_ip" {
  description = "Public IP Address of Frontend EC2 Instance"
  value       = aws_instance.frontend_instance.public_ip
}

output "backend_private_ip" {
  description = "Private IP Address of Backend EC2 Instance"
  value       = aws_instance.backend_instance.private_ip
}

output "backend_public_ip" {
  description = "Public IP Address of Backend EC2 Instance"
  value       = aws_instance.backend_instance.public_ip
}

output "frontend_application_url" {
  description = "Public Web Application URL"
  value       = "http://${aws_instance.frontend_instance.public_ip}"
}
