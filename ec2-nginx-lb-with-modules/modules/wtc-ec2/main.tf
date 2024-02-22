#Variables
variable "subnet_private" {}
variable "nat_gateway" {}
variable "aws_sg" {}

#Ouputs to pass to root
output "ec2-instance" {
  value = aws_instance.ec2.id
}

# EC2 instance + Nginx through template
resource "aws_instance" "ec2" {
  ami                         = "ami-05fb0b8c1424f266b"
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_private
  vpc_security_group_ids      = [var.aws_sg]
  associate_public_ip_address = false
  user_data                   = templatefile("user_data", {})
  key_name                    = "ssh_key"

  depends_on = [var.nat_gateway]
}

