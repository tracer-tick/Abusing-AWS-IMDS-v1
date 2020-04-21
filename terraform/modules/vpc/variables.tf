data "aws_availability_zones" "az" {}

variable "aws_internet_gateway_name" {
  type        = string
  description = "The name of the internet gateway"
}

variable "aws_route_table_public_name" {
  type        = string
  description = "The name of the public route table"
}

variable "num_public_subnets" {
  type        = number
  default     = 2
  description = "The number of public subnets to be created in the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}