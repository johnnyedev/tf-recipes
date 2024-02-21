
output "alb_dns" {
  value = aws_lb.terraform-lab.dns_name
}
