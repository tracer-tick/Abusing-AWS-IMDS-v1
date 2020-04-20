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

variable "public_subnet_id" {
  type        = string
  default     = ""
  description = "A public subnet ID of a public subnet in a VPC"
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

variable "name" {
  type        = string
  default     = "vulnerable"
  description = "The name of the vulnerable web app"
}
