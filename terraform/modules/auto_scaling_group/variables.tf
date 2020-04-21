data "aws_ami" "amazon_linux_2" {
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

variable "aws_autoscaling_group_name" {
  type        = string
  description = "The name of the auto scaling group"
}
variable "aws_autoscaling_group_desired_capacity" {
  type        = number
  description = "The number of Amazon EC2 instances that should be running in the group"
}
variable "aws_autoscaling_group_max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
}
variable "aws_autoscaling_group_min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
}

variable "instance_type" {
  type        = string
  description = "The Instance Type of the instance to launch"
}

variable "instance_name" {
  type        = string
  description = "The name of the instance to launch"
}

variable "security_group_id" {
  type        = string
  description = "The associated Security Group IDS"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to launch resources in"
}

variable "alb_target_group_arns" {
  type        = list(string)
  description = "A list of aws_alb_target_group ARNs, for use with Application or Network Load Balancing"
}

variable "aws_launch_configuration_name" {
  type        = string
  description = "The name of the launch configuration"
}

variable "assume_role_policy" {
  type        = string
  description = "AWS IAM policy that allows an EC2 instance to AssumeRole"
  default     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

variable "aws_iam_role_name" {
  type        = string
  description = "Role that will be attached to our vulnerable web application"
}

variable "aws_iam_policy_1_name" {
  type        = string
  description = "Policy that allows S3 Get, Head, and List actions"
}

variable "aws_iam_policy_1_json" {
  type        = string
  description = "Policy that allows S3 Get, Head, and List actions"
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:Head*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

variable "aws_iam_policy_2_name" {
  type        = string
  description = "Policy that allows basic CloudWatch Logs actions"
}

variable "aws_iam_policy_2_json" {
  type        = string
  description = "Policy that allows basic CloudWatch Logs actions"
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

variable "aws_iam_instance_profile_name" {
  type        = string
  description = "The instance profile that will be attached to our vulnerable web application"
}