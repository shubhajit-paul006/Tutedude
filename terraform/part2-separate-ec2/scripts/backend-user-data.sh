#!/bin/bash
set -e

# Update and install dependencies
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y git python3 python3-pip python3-venv

# Clone application repository
mkdir -p /opt/tutedude
cd /opt/tutedude
git clone https://github.com/shubhajit-paul006/Tutedude.git app || true
cd /opt/tutedude/app/backend

# Setup Python Virtual Environment and Gunicorn
python3 -m venv venv
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt
./venv/bin/pip install gunicorn

# Setup Systemd Service for Flask Backend
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
