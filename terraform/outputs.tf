output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_public_dns" {
  value = module.ec2.public_dns
}

output "jenkins_url" {
  value = "http://${module.ec2.public_ip}:8080"
}

output "flask_url" {
  value = "http://${module.ec2.public_ip}:5000"
}