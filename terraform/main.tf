module "application_load_balancer" {
  source = "./modules/application_load_balancer"

  alb_name                  = var.alb_name
  alb_target_group_name     = var.alb_target_group_name
  alb_target_group_port     = var.alb_target_group_port
  alb_target_group_protocol = var.alb_target_group_protocol
  public_subnet_ids         = module.vpc.subnets
  security_group_id         = [module.security_group_alb.aws_security_group_id]
  vpc_id                    = module.vpc.vpc-id
}

module "auto_scaling_group" {
  source = "./modules/auto_scaling_group"

  alb_target_group_arns                  = [module.application_load_balancer.arn]
  aws_autoscaling_group_desired_capacity = var.aws_autoscaling_group_desired_capacity
  aws_autoscaling_group_max_size         = var.aws_autoscaling_group_max_size
  aws_autoscaling_group_min_size         = var.aws_autoscaling_group_min_size
  aws_autoscaling_group_name             = var.aws_autoscaling_group_name
  aws_iam_instance_profile_name          = var.aws_iam_instance_profile_name
  aws_iam_policy_1_name                  = var.aws_iam_policy_1_name
  aws_iam_policy_2_name                  = var.aws_iam_policy_2_name
  aws_iam_role_name                      = var.aws_iam_role_name
  aws_launch_configuration_name          = var.aws_launch_configuration_name
  instance_type                          = var.instance_type
  instance_name                          = var.instance_name
  public_subnet_ids                      = module.vpc.subnets
  security_group_id                      = module.security_group_ec2_instances.aws_security_group_id
}

module "cloudwatch_log_groups" {
  source = "./modules/cloudwatch_logs"

  retention_in_days = var.retention_in_days
}

module "security_group_ec2_instances" {
  source = "./modules/security_group"

  aws_security_group_name = "ec2_instances"
  description             = "Inbound: HTTP and HTTPS traffic from ${join(", ", var.locked_down_ip_addresses)} from ALB. Outbound: any to all."
  vpc_id                  = module.vpc.vpc-id
}

module "security_group_alb" {
  source = "./modules/security_group"

  aws_security_group_name = "alb"
  description             = "Inbound: HTTP and HTTPS traffic from from all. Outbound: all to ec2 instances."
  vpc_id                  = module.vpc.vpc-id
}

module "security_group_rule_1" {
  source = "./modules/security_group_rule/sg"

  aws_security_group_rule_description              = "Allows HTTP traffic inbound from ALB."
  aws_security_group_rule_from_port                = 80
  aws_security_group_rule_protocol                 = "tcp"
  aws_security_group_rule_security_group_id        = module.security_group_ec2_instances.aws_security_group_id
  aws_security_group_rule_source_security_group_id = module.security_group_alb.aws_security_group_id
  aws_security_group_rule_to_port                  = 80
  aws_security_group_rule_type                     = "ingress"
}

module "security_group_rule_2" {
  source = "./modules/security_group_rule/sg"

  aws_security_group_rule_description              = "Allows HTTPS traffic inbound from ALB."
  aws_security_group_rule_from_port                = 443
  aws_security_group_rule_protocol                 = "tcp"
  aws_security_group_rule_security_group_id        = module.security_group_ec2_instances.aws_security_group_id
  aws_security_group_rule_source_security_group_id = module.security_group_alb.aws_security_group_id
  aws_security_group_rule_to_port                  = 443
  aws_security_group_rule_type                     = "ingress"
}

module "security_group_rule_3" {
  source = "./modules/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = ["0.0.0.0/0"]
  aws_security_group_rule_description       = "Allows all traffic outbound to any IP address"
  aws_security_group_rule_from_port         = 0
  aws_security_group_rule_protocol          = "-1"
  aws_security_group_rule_security_group_id = module.security_group_ec2_instances.aws_security_group_id
  aws_security_group_rule_to_port           = 0
  aws_security_group_rule_type              = "egress"
}

module "security_group_rule_4" {
  source = "./modules/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = var.locked_down_ip_addresses
  aws_security_group_rule_description       = "Allows HTTP traffic inbound from ${join(", ", var.locked_down_ip_addresses)}"
  aws_security_group_rule_from_port         = 80
  aws_security_group_rule_protocol          = "tcp"
  aws_security_group_rule_security_group_id = module.security_group_alb.aws_security_group_id
  aws_security_group_rule_to_port           = 80
  aws_security_group_rule_type              = "ingress"
}

module "security_group_rule_5" {
  source = "./modules/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = var.locked_down_ip_addresses
  aws_security_group_rule_description       = "Allows HTTPS traffic inbound from ${join(", ", var.locked_down_ip_addresses)}"
  aws_security_group_rule_from_port         = 443
  aws_security_group_rule_protocol          = "tcp"
  aws_security_group_rule_security_group_id = module.security_group_alb.aws_security_group_id
  aws_security_group_rule_to_port           = 443
  aws_security_group_rule_type              = "ingress"
}

module "security_group_rule_6" {
  source = "./modules/security_group_rule/sg"

  aws_security_group_rule_description              = "Allows HTTPS traffic inbound from ALB."
  aws_security_group_rule_from_port                = 0
  aws_security_group_rule_protocol                 = "-1"
  aws_security_group_rule_security_group_id        = module.security_group_alb.aws_security_group_id
  aws_security_group_rule_source_security_group_id = module.security_group_ec2_instances.aws_security_group_id
  aws_security_group_rule_to_port                  = 0
  aws_security_group_rule_type                     = "egress"
}

module "vpc" {
  source = "./modules/vpc"

  aws_internet_gateway_name   = var.aws_internet_gateway_name
  aws_route_table_public_name = var.aws_route_table_public_name
  vpc_cidr_block              = var.vpc_cidr_block
  vpc_name                    = var.vpc_name
}