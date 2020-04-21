variable "alb_name" {
  type        = string
  description = "The name of the ALB"
}

variable "alb_target_group_name" {
  type        = string
  description = "The name of the target group"
}

variable "alb_target_group_port" {
  type        = number
  description = "The port on which targets receive traffic, unless overridden when registering a specific target"
}

variable "alb_target_group_protocol" {
  type        = string
  description = "The protocol to use for routing traffic to the targets"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "A list of public subnet IDs to attach to the ALB"
}

variable "security_group_id" {
  type        = list(string)
  description = "A list of security group IDs to assign to the ALB"
}

variable "vpc_id" {
  type        = string
  description = "The identifier of the VPC in which to create the target group"
}