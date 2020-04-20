variable "name" {
  type        = string
  default     = "alb"
  description = "The name of the ALB"
}

variable "security_group_id" {
  type        = string
  default     = ""
  description = "A security group ID to assign to the ALB"
}

variable "public_subnet_ids" {
  type        = list(string)
  default     = ["",]
  description = "A list of public subnet IDs to attach to the ALB."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC ID where the security group will live"
}

variable "instance_id" {
  type        = string
  default     = ""
  description = "The ID of the target for the target group"
}