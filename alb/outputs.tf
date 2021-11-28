output "PRIVATE_ALB_ARN" {
  value = aws_lb.privatelb.arn
}

output "PUBLIC_ALB_ARN" {
  value = aws_lb.publiclb.arn
}

output "PRIVATE_ALB_DNS" {
  value = aws_lb.privatelb.dns_name
}

output "PUBLIC_ALB_DNS" {
  value = aws_lb.publiclb.dns_name
}
output "PRIVATE_LISTENER_ARN" {
  value = aws_lb_listener.privatelb.arn
}
