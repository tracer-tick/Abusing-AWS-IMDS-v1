data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The instance type of the vulnerable web app"
}

variable "name" {
  type        = string
  default     = "vulnerable"
  description = "The name of the vulnerable web app"
}

variable "security_group_id" {
  type        = string
  default     = ""
  description = "A security group ID to host the web app"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC ID where the security group will live"
}

variable "public_subnet_ids" {
  type        = list(string)
  default     = ["", ]
  description = "A list of subnet IDs to launch resources in"
}

variable "alb_tg_arn" {
  type        = string
  default     = ""
  description = "ARN of the ALB target group"
}