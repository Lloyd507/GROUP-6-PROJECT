#!/bin/bash

# ------------------------------------------
# Simple Note-Taking Server Setup Script
# Using Docker and UFW
# ------------------------------------------

set -e  

JOPLIN_PORT=22300

echo " Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Docker..."
sudo apt install -y docker.io ufw

echo " Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Configuring UFW firewall..."
sudo ufw allow OpenSSH
sudo ufw allow ${JOPLIN_PORT}/tcp
sudo ufw --force enable

echo " Pulling and running Joplin Server container..."

sudo docker run -d \
  --name joplin \
  -p ${JOPLIN_PORT}:22300 \
  -e APP_BASE_URL="http://localhost:22300" \
  -e DB_CLIENT=sqlite \
  -e POSTGRES_PASSWORD=admin \
  joplin/server:latest

echo "Done!"
echo "Access your app at: http:localhost:${JOPLIN_PORT}"
