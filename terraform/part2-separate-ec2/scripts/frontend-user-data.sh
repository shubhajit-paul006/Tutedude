#!/bin/bash
set -e

# Update and install dependencies
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y git curl nginx

# Install Node.js 20 LTS & PM2
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
npm install -g pm2

# Clone application repository
mkdir -p /opt/tutedude
cd /opt/tutedude
git clone https://github.com/shubhajit-paul006/Tutedude.git app || true
cd /opt/tutedude/app/frontend

# Setup Frontend Application with injected Backend Private IP
npm ci --only=production || npm install --production

# Injected backend private IP from Terraform template
export BACKEND_URL="http://${backend_ip}:5000"
export PORT="3000"
export NODE_ENV="production"

# Write environment file for PM2 process
cat <<EOF > /opt/tutedude/app/frontend/.env
BACKEND_URL=http://${backend_ip}:5000
PORT=3000
NODE_ENV=production
EOF

pm2 start server.js --name "node-frontend" --env production
pm2 save
pm2 startup systemd -u root --hp /root || true

# Setup Nginx Reverse Proxy
cat <<'NGINX_CONF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX_CONF

nginx -t
systemctl restart nginx
