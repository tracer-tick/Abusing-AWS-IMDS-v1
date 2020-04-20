output "public_dns" {
  value = aws_instance.vulnerable_web_app.public_dns
}