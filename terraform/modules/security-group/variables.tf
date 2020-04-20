variable "name-ec2" {
  type        = string
  default     = "ec2"
  description = "The name of the security group where the web server will be hosted"
}

variable "name-alb" {
  type        = string
  default     = "alb"
  description = "The name of the security group where the web server will be hosted"
}


variable "locked-down-ip-addresses" {
  type        = list(string)
  default     = ["", ]
  description = "List of IP addresses to restrict access to since this is a vulnerable web application"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC ID where the security group will live"
}