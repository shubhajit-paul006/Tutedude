#!/bin/bash
set -e

apt-get update -y
apt-get install -y git curl

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
npm install -g pm2

mkdir -p /home/ubuntu/app
git clone https://github.com/shubhajit-paul006/Tutedude.git /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

cd /home/ubuntu/app/frontend
npm install --production

# Start Express with Backend Private/Public IP
sudo -u ubuntu pm2 start server.js --name frontend --env PORT=3000,BACKEND_URL=http://:5000
sudo -u ubuntu pm2 save
