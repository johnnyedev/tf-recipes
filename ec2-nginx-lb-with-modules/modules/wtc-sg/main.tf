#Variables
variable "aws_vpc" {}

#Outputs to pass to root
output "lb-securitygroup" {
  value = aws_security_group.load-balancer.id
}

output "ec2-securitygroup" {
  value = aws_security_group.ec2.id
}

#LB SG (Public Internet Traffic -> LB)
resource "aws_security_group" "load-balancer" {
  name   = "load_balancer_security_group"
  vpc_id = var.aws_vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2 SG (Public Internet Traffic@ALB -> EC2, ssh -> EC2)
resource "aws_security_group" "ec2" {
  name   = "ec2_security_group"
  vpc_id = var.aws_vpc

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load-balancer.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

