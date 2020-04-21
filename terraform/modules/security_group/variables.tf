variable "aws_security_group_name" {
  type        = string
  description = "The name of the security group"
}

variable "description" {
  type        = string
  description = "The description of the security group"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the security group will live"
}