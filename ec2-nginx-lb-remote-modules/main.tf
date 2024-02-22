terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      #### version 5 or later for domain attrb under eip in network.tf
      version = "~> 5.0"
    }
  }
  ### TF CLI Version ###
  required_version = ">= 1.2.0"
}
### Outputs ###
output "lb-endpoint" {
  value = module.aws_lb.lb-dns-name
}

### Provider Config ###
provider "aws" {
  region = "us-east-2"
}

### MODULES ###

### SSH Key ###
module "aws_key_pair" {
  source = "github.com/johnnyehashi/wtc-ssh"
}

### EC2 instance + Nginx ###
module "aws_instance" {
  source = "github.com/johnnyehashi/wtc-ec2"  
  subnet_private = module.aws_vpc.subnet_private
  nat_gateway    = module.aws_vpc.ngw-id
  aws_sg         = module.aws_security_group.ec2-securitygroup
}

### Load Balancer ###
module "aws_lb" {
  source = "github.com/johnnyehashi/wtc-lb"
  aws_vpc           = module.aws_vpc.vpc-id
  subnet_public1    = module.aws_vpc.subnet_public1
  subnet_public2    = module.aws_vpc.subnet_public2
  lb-security-group = module.aws_security_group.lb-securitygroup
  aws_instance-ec2  = module.aws_instance.ec2-instance
}

### VPC ###
module "aws_vpc" {
   source = "github.com/johnnyehashi/wtc-vpc" 
}

### Security Groups ###
module "aws_security_group" {
   source = "github.com/johnnyehashi/wtc-sg"
  aws_vpc = module.aws_vpc.vpc-id
}



