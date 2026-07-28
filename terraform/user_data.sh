#!/bin/bash
exec > /var/log/user_data.log 2>&1

# Update system
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y \
  git \
  curl \
  wget \
  docker.io \
  docker-compose-v2

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Run Jenkins as Docker container with Docker socket mounted
docker volume create jenkins_home

docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  jenkins/jenkins:lts

# Wait for Jenkins container to fully start
sleep 30

# Install docker-compose inside Jenkins container
docker exec -u root jenkins curl -L \
  "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose

docker exec -u root jenkins chmod +x /usr/local/bin/docker-compose

# Fix Docker socket permissions for Jenkins
docker exec -u root jenkins chmod 666 /var/run/docker.sock

echo "user_data.sh completed successfully"