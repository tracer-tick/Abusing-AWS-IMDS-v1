output "public_dns" {
  value = aws_instance.vulnerable_web_app.public_dns
}

output "ec2_instance_id" {
  value = aws_instance.vulnerable_web_app.id
}