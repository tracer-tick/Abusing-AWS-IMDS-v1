resource "aws_security_group" "web_server_access" {
  name        = var.name-ec2
  description = "Inbound: HTTP and HTTPS inboud from ${var.name-alb}. Outbound: any to all"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.name-ec2,
    vpc  = var.vpc_id,
  }
}

resource "aws_security_group_rule" "inbound-80-restricted" {
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  source_security_group_id = aws_security_group.alb.id
  security_group_id = aws_security_group.web_server_access.id
  description       = "Allows HTTP traffic inbound from ${join(", ", var.locked-down-ip-addresses)}"
}

resource "aws_security_group_rule" "inbound-443-restricted" {
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  source_security_group_id = aws_security_group.alb.id
  security_group_id = aws_security_group.web_server_access.id
  description       = "Allows HTTPS traffic inbound from ${join(", ", var.locked-down-ip-addresses)}"
}

resource "aws_security_group_rule" "outbound-any-all" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "egress"
  security_group_id = aws_security_group.web_server_access.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allows all traffic outbound to any IP address"
}

resource "aws_security_group" "alb" {
  name        = var.name-alb
  description = "Inbound: HTTP and HTTPS inboud from ${join(", ", var.locked-down-ip-addresses)}. Outbound: ${var.name-ec2} security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.name-alb,
    vpc  = var.vpc_id,
  }
}

resource "aws_security_group_rule" "inbound-80-alb-restricted" {
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = var.locked-down-ip-addresses
  security_group_id = aws_security_group.alb.id
  description       = "Allows HTTPS traffic inbound from ${join(", ", var.locked-down-ip-addresses)}"
}

resource "aws_security_group_rule" "inbound-443-alb-restricted" {
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = var.locked-down-ip-addresses
  security_group_id = aws_security_group.alb.id
  description       = "Allows HTTPS traffic inbound from ${join(", ", var.locked-down-ip-addresses)}"
}

resource "aws_security_group_rule" "outbound-any-to-ec2" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  source_security_group_id = aws_security_group.web_server_access.id
  description       = "Allows all traffic outbound to ec2 web servers"
}