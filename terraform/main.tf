terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "ap-south-2"
}

# VPC
resource "aws_vpc" "flask_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "flask-jenkins-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "flask_subnet" {
  vpc_id = aws_vpc.flask_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "flask-jenkins-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "flask_igw" {
  vpc_id = aws_vpc.flask_vpc.id

  tags = {
    Name = "flask-jenkins-igw"
  }
}

# Route Table
resource "aws_route_table" "flask_rt" {
  vpc_id = aws_vpc.flask_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flask_igw.id
  }

  tags = {
    Name = "flask-jenkins-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "flask_rta" {
  subnet_id = aws_subnet.flask_subnet.id
  route_table_id = aws_route_table.flask_rt.id
}

# Key Pair
resource "aws_key_pair" "flask_key" {
  key_name   = "flask-key"
  public_key = file(var.public_key_path)
}

#Security Group 
resource "aws_security_group" "flask_sg" {
  name        = "flask-jenkins-sg"
  description = "Allow SSH , Jenkins and HTTP traffic"
  vpc_id      = aws_vpc.flask_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins Port"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask App Port"
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-jenkins-sg"
  }
}

# EC2 Instance
resource "aws_instance" "flask_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.flask_key.key_name
  subnet_id = aws_subnet.flask_subnet.id
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  user_data = file("user_data.sh")

  tags = {
    Name = "flask-jenkins-server"
  }
}