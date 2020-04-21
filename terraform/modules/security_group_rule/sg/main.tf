resource "aws_security_group_rule" "aws_security_group_rule" {
  description              = var.aws_security_group_rule_description
  from_port                = var.aws_security_group_rule_from_port
  protocol                 = var.aws_security_group_rule_protocol
  security_group_id        = var.aws_security_group_rule_security_group_id
  source_security_group_id = var.aws_security_group_rule_source_security_group_id
  to_port                  = var.aws_security_group_rule_to_port
  type                     = var.aws_security_group_rule_type
}
