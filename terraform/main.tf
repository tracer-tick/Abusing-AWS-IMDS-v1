#####################################
# Provider
#####################################
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

#####################################
# Variables
#####################################
variable "my_ip" {
  type    = string
  default = "99.44.98.252/32" #update this value
}

#####################################
# Modules
#####################################
module "vpc" {
  source     = ".//modules//vpc"
  name       = "imds-v1-custom-vpc"
  cidr_block = "192.168.0.0/16"
}

module "security-group" {
  source   = ".//modules//security-group"
  name-ec2 = "public-web-app"
  name-alb = "alb"
  vpc_id   = module.vpc.vpc-id
  locked-down-ip-addresses = [
    var.my_ip,
  ]
}

module "application-load-balancer" {
  source            = ".//modules//application-load-balancer"
  public_subnet_ids = module.vpc.subnets
  security_group_id = module.security-group.alb-security-group-id
  vpc_id            = module.vpc.vpc-id
}

module "auto-scaling-group" {
  source            = ".//modules//auto-scaling-group"
  name              = "vulnerable-web-app"
  instance_type     = "t2.micro"
  public_subnet_ids = module.vpc.subnets
  security_group_id = module.security-group.web-security-group-id
  vpc_id            = module.vpc.vpc-id
  alb_tg_arn        = module.application-load-balancer.arn
}

module "create-log-groups" {
  source            = ".//modules//cloudwatch-logs"
  retention_in_days = 1
}

#####################################
# Outputs
#####################################
output "alb_public_dns" {
  value = module.application-load-balancer.public_dns
}