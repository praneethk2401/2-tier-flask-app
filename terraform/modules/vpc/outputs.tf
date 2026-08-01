variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "vpc_name" {
  default = "flask-jenkins-vpc"
}

variable "subnet_name" {
  default = "flask-jenkins-subnet"
}

variable "igw_name" {
  default = "flask-jenkins-igw"
}

variable "rt_name" {
  default = "flask-jenkins-rt"
}