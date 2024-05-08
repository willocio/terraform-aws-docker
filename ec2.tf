data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "this" {
  key_name   = "docker-key-pair"
  public_key = file("./docker-key-pair.pub")
}

resource "aws_instance" "docker" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name
  user_data                   = file("install-docker.sh")
  vpc_security_group_ids      = [aws_default_security_group.default.id]

  tags = {
    Name = "docker"
  }
}