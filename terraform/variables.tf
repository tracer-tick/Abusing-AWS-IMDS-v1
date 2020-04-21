## Application Load Balancer ##
variable "alb_name" {
  type = string
}
variable "alb_target_group_name" {
  type = string
}
variable "alb_target_group_port" {
  type = number
}
variable "alb_target_group_protocol" {
  type = string
}

## Auto-scaling ##
variable "aws_launch_configuration_name" {
  type = string
}
variable "aws_autoscaling_group_desired_capacity" {
  type = number
}
variable "aws_autoscaling_group_max_size" {
  type = number
}
variable "aws_autoscaling_group_min_size" {
  type = number
}
variable "aws_autoscaling_group_name" {
  type = string
}

## CloudWatch Logs ##
variable "retention_in_days" {
  type = number
}

## EC2 ##
variable "instance_name" {
  type = string
}
variable "instance_type" {
  type = string
}

## IAM ##
variable "aws_iam_instance_profile_name" {
  type = string
}
variable "aws_iam_policy_1_name" {
  type = string
}
variable "aws_iam_policy_2_name" {
  type = string
}
variable "aws_iam_role_name" {
  type = string
}

## Security Groups ##
variable "alb_security_group_name" {
  type = string
}
variable "ec2_security_group_name" {
  type = string
}
variable "locked_down_ip_addresses" {
  type = list(string)
}
## VPC ##
variable "aws_internet_gateway_name" {
  type = string
}
variable "aws_route_table_public_name" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}
variable "vpc_name" {
  type = string
}