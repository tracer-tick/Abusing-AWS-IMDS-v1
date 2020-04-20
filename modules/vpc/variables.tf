data "aws_availability_zones" "az" {}

variable "name" {
  type        = string
  default     = "abusing-IMDS-v1"
  description = "The name of the VPC"
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC"
}