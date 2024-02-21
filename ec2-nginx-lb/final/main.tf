terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      #### version 5 or later for domain attrb under eip in network.tf
      version = "~> 5.0"
    }
  }
  #### TF CLI Version
  required_version = ">= 1.2.0"
}

# Add provider + set region
provider "aws" {
  region = "us-east-2"
}

# Add SSH Key
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("ssh_key.pub")
}

# EC2 instance + Nginx through template
resource "aws_instance" "ec2" {
  ami                         = "ami-05fb0b8c1424f266b"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_private.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = false
  user_data                   = templatefile("user_data", {})
  key_name                    = "ssh_key"

  depends_on = [aws_nat_gateway.ngw]
}

