output "arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

output "public_dns" {
  value = aws_lb.alb.dns_name
}