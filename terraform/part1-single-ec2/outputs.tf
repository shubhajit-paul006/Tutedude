output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP Address of the EC2 Instance"
  value       = aws_instance.app_server.public_ip
}

output "frontend_url" {
  description = "Public URL for Node.js Frontend Application"
  value       = "http://${aws_instance.app_server.public_ip}:3000"
}

output "backend_api_url" {
  description = "Public URL for Flask Backend API"
  value       = "http://${aws_instance.app_server.public_ip}:5000/api"
}

output "nginx_url" {
  description = "Public URL accessed via Reverse Proxy"
  value       = "http://${aws_instance.app_server.public_ip}"
}
