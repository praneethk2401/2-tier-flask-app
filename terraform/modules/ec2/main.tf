resource "aws_key_pair" "flask_key" {
  key_name   = "flask-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "flask_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.flask_key.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  user_data              = file(var.user_data_path)

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "flask-jenkins-server"
  }
}