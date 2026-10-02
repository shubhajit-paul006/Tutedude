#!/bin/bash
set -e

apt-get update -y
apt-get install -y git curl nginx python3 python3-pip python3-venv

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
npm install -g pm2

mkdir -p /home/ubuntu/app
git clone https://github.com/shubhajit-paul006/Tutedude.git /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

# Backend Setup
cd /home/ubuntu/app/backend
python3 -m venv venv
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt gunicorn
sudo -u ubuntu ./venv/bin/gunicorn --workers 3 --bind 127.0.0.1:5000 --daemon app:app

# Frontend Setup
cd /home/ubuntu/app/frontend
npm install --production
sudo -u ubuntu pm2 start server.js --name frontend --env PORT=3000,BACKEND_URL=http://127.0.0.1:5000
sudo -u ubuntu pm2 save

# Nginx Reverse Proxy
cat << 'EOF' > /etc/nginx/sites-available/default
server {
 listen 80 default_server;
 server_name _;

 location / {
 proxy_pass http://127.0.0.1:3000;
 proxy_http_version 1.1;
 proxy_set_header Upgrade ;
 proxy_set_header Connection 'upgrade';
 proxy_set_header Host System.Management.Automation.Internal.Host.InternalHost;
 proxy_set_header X-Real-IP ;
 proxy_set_header X-Forwarded-For ;
 proxy_set_header X-Forwarded-Proto ;
 }

 location /api {
 proxy_pass http://127.0.0.1:5000/api;
 proxy_set_header Host System.Management.Automation.Internal.Host.InternalHost;
 proxy_set_header X-Real-IP ;
 }
}
EOF

nginx -t
systemctl restart nginx
systemctl enable nginx
