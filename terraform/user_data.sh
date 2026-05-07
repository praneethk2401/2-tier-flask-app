#!/bin/bash

# Update system
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y \
  git \
  curl \
  docker.io \
  docker-compose-v2 \
  openjdk-17-jdk

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | \
  tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

# Start and enable Jenkins
systemctl start jenkins
systemctl enable jenkins

# Add jenkins user to docker group
usermod -aG docker jenkins

# Restart jenkins to apply docker group
systemctl restart jenkins