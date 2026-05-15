variable "region" {
  description = "AWS region to deploy resources"
  default = "ap-south-2"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI for ap-south-2"
  default = "ami-0dd47bfc890a23f07"
}

variable "instance_type" {
  description = "EC2 Instance type"
  default = "t3.micro"
}

variable "public_key_path" {
  description = "Path to local SSH public key"
  default = "~/.ssh/flask-key.pub"
}