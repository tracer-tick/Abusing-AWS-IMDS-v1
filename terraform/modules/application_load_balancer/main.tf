resource "aws_lb" "alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.security_group_id
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = var.alb_name,
    vpc  = var.vpc_id
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_target_group_port
  protocol          = var.alb_target_group_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = var.alb_target_group_name
  port     = var.alb_target_group_port
  protocol = var.alb_target_group_protocol
  vpc_id   = var.vpc_id
}