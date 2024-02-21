
output "lb-endpoint" {
  value = aws_lb.lb-nginx.dns_name
}
