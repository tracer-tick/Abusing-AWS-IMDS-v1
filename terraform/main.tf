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

module "create-vpc" {
  source     = ".//modules//vpc"
  name       = "imds-v1-custom-vpc"
  cidr_block = "192.168.0.0/16"
}

module "create-security-group" {
  source   = ".//modules//security-group"
  name-ec2 = "public-web-app"
  name-alb = "alb"
  vpc_id   = module.create-vpc.vpc-id
  locked-down-ip-addresses = [
    var.my_ip,
  ]
}

module "create-application-load-balancer" {
  source            = ".//modules//application-load-balancer"
  public_subnet_ids = module.create-vpc.subnets
  security_group_id = module.create-security-group.alb-security-group-id
  vpc_id            = module.create-vpc.vpc-id
}

module "create-auto-scaling-group" {
  source            = ".//modules//auto-scaling-group"
  name              = "vulnerable-web-app"
  instance_type     = "t2.micro"
  public_subnet_ids = module.create-vpc.subnets
  security_group_id = module.create-security-group.web-security-group-id
  vpc_id            = module.create-vpc.vpc-id
  alb_tg_arn        = module.create-application-load-balancer.arn
}

#####################################
# Outputs
#####################################
output "alb_public_dns" {
  value = module.create-application-load-balancer.public_dns
}