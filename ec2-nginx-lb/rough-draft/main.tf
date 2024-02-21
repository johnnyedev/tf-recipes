
provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region                   = "us-east-2"
}


resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("ssh_key.pub")
}

resource "aws_instance" "ec2" {
  ami                         = "ami-0568773882d492fc8"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_private.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = false
  user_data                   = templatefile("user_data.tftpl", { department = "learn", name = "terraform" })
  key_name                    = "ssh_key"

  depends_on = [aws_nat_gateway.ngw]
}

#resource "aws_instance" "ec2" {
#  ami                         = "ami-0568773882d492fc8"
#  instance_type               = "t3.micro"
#  subnet_id                   = aws_subnet.subnet_private.id
#  vpc_security_group_ids      = [aws_security_group.ec2.id,]
#  associate_public_ip_address = false
#  user_data                   = templatefile("user_data.tftpl", { department = "learn", name = "terraform" })
#  key_name                    = "ssh_key"
#
#  depends_on = [aws_nat_gateway.ngw]
#}

#resource "aws_launch_configuration" "ec2" {
#  name            = "nginx-ec2"
#  image_id        = "ami-0568773882d492fc8"
#  instance_type   = "t2.micro"
#  security_groups = [aws_security_group.ec2.id]
#  #  key_name                    = aws_key_pair.terraform-lab.key_name
#  #  iam_instance_profile        = aws_iam_instance_profile.session-manager.id
#  associate_public_ip_address = false
#  user_data                   = <<-EOL
#  #!/bin/bash -xe
#  sudo yum update -y
#  sudo yum -y install docker
#  sudo service docker start
#  sudo usermod -a -G docker ec2-user
#  sudo chmod 666 /var/run/docker.sock
#  docker pull nginx
#  docker tag nginx my-nginx
#  docker run --rm --name nginx-server -d -p 80:80 -t my-nginx
#  EOL
#  depends_on                  = [aws_nat_gateway.ngw]
#}

