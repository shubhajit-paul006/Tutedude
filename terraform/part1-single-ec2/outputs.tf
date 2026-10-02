output instance_id {
 description = ID of the provisioned EC2 instance
 value = aws_instance.fullstack_app.id
}

output public_ip {
 description = Public IP address of the EC2 instance
 value = aws_instance.fullstack_app.public_ip
}

output frontend_url {
 description = URL to access Express frontend via Nginx
 value = http://
}

output direct_frontend_url {
 description = Direct Node.js Express URL
 value = http://:3000
}

output backend_api_url {
 description = Direct Flask API URL
 value = http://:5000/api
}
