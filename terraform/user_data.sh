#!/bin/bash
exec > /var/log/user_data.log 2>&1

apt-get update -y
apt-get upgrade -y

apt-get install -y \
  git \
  curl \
  wget \
  docker.io \
  docker-compose-v2

systemctl start docker
systemctl enable docker

# Run Jenkins as Docker container
docker volume create jenkins_home

docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

echo "user_data.sh completed successfully"