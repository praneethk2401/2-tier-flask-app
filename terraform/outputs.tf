output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.flask_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.flask_server.public_dns
}

output "jenkins_url" {
  description = "Jenkins dashboard URL"
  value       = "http://${aws_instance.flask_server.public_ip}:8080"
}

output "flask_url" {
  description = "Flask app URL"
  value       = "http://${aws_instance.flask_server.public_ip}:5000"
}