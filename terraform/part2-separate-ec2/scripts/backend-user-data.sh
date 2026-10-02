#!/bin/bash
set -e

apt-get update -y
apt-get install -y git python3 python3-pip python3-venv

mkdir -p /home/ubuntu/app
git clone https://github.com/shubhajit-paul006/Tutedude.git /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

cd /home/ubuntu/app/backend
python3 -m venv venv
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt gunicorn

sudo -u ubuntu ./venv/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 --daemon app:app
