resource "aws_security_group" "aws_security_group" {
  description = var.description
  name        = var.aws_security_group_name
  vpc_id      = var.vpc_id

  tags = {
    Name = var.aws_security_group_name,
    vpc  = var.vpc_id,
  }
}