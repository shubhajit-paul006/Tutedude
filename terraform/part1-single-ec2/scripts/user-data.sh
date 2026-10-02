#!/bin/bash
set -e

# Update and install dependencies
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y git curl python3 python3-pip python3-venv nginx

# Install Node.js 20 LTS & PM2
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
npm install -g pm2

# Clone application repository
mkdir -p /opt/tutedude
cd /opt/tutedude
git clone https://github.com/shubhajit-paul006/Tutedude.git app || true
cd /opt/tutedude/app

# Setup Flask Backend
cd /opt/tutedude/app/backend
python3 -m venv venv
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt
./venv/bin/pip install gunicorn

# Setup Systemd service for Flask Backend
cat <<'SERVICE' > /etc/systemd/system/flask-backend.service
[Unit]
Description=TuteDude Flask Backend Service
After=network.target

[Service]
User=root
WorkingDirectory=/opt/tutedude/app/backend
Environment="PATH=/opt/tutedude/app/backend/venv/bin"
Environment="PORT=5000"
Environment="FLASK_ENV=production"
ExecStart=/opt/tutedude/app/backend/venv/bin/gunicorn --bind 0.0.0.0:5000 --workers 3 app:app
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable flask-backend
systemctl start flask-backend

# Setup Node.js Frontend with PM2
cd /opt/tutedude/app/frontend
npm ci --only=production || npm install --production
export BACKEND_URL="http://127.0.0.1:5000"
export PORT="3000"
export NODE_ENV="production"
pm2 start server.js --name "node-frontend" --env production
pm2 save
pm2 startup systemd -u root --hp /root || true

# Setup Nginx Reverse Proxy
cat <<'NGINX_CONF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    # Reverse proxy /api to Flask Backend
    location /api {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Reverse proxy all other traffic to Node.js Frontend
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
