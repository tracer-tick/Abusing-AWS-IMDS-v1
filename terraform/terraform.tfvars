## Application Load Balancer ##
alb_name                  = "application-load-balancer"
alb_target_group_name     = "application-load-balancer-tg"
alb_target_group_port     = 80
alb_target_group_protocol = "HTTP"

## Auto-scaling ##
aws_launch_configuration_name          = "asg-lc"
aws_autoscaling_group_desired_capacity = 1
aws_autoscaling_group_max_size         = 1
aws_autoscaling_group_min_size         = 1
aws_autoscaling_group_name             = "asg"


## CloudWatch Logs ##
retention_in_days = 1

## EC2 ##
instance_name = "vulnerable"
instance_type = "t2.micro"

## IAM ##
aws_iam_instance_profile_name = "instance-profile"
aws_iam_policy_1_name         = "s3-read-only"
aws_iam_policy_2_name         = "cloudwatch-logs-access"
aws_iam_role_name             = "s3-and-cloudwatch"

## Security Groups ##
alb_security_group_name  = "alb-sg"
ec2_security_group_name  = "public-web-app-sg"
locked_down_ip_addresses = ["99.44.98.252/32", ]

## VPC ##
aws_internet_gateway_name   = "igw"
aws_route_table_public_name = "rt-public"
vpc_cidr_block              = "192.168.0.0/16"
vpc_name                    = "imds-v1-custom-vpc"