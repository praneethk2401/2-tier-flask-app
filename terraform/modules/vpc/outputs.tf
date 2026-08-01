output "vpc_id" {
  value = aws_vpc.flask_vpc.id
}

output "subnet_id" {
  value = aws_subnet.flask_subnet.id
}
