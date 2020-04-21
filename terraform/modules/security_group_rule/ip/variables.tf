variable "aws_security_group_rule_cidr_blocks" {
  type        = list(string)
  description = ""
}

variable "aws_security_group_rule_description" {
  type        = string
  description = ""
}

variable "aws_security_group_rule_from_port" {
  type        = number
  description = ""
}

variable "aws_security_group_rule_protocol" {
  type        = string
  description = ""
}

variable "aws_security_group_rule_security_group_id" {
  type        = string
  description = ""
}

variable "aws_security_group_rule_to_port" {
  type        = number
  description = ""
}

variable "aws_security_group_rule_type" {
  type        = string
  description = ""
}