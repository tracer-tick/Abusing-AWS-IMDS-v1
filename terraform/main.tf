#####################################
# Provider
#####################################
provider "aws" {
  profile = "default"
  region  = var.region
}

#####################################
# Variables
#####################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to which we will deploy our code"
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
  source = ".//modules//security-group"
  name   = "public-web-app"
  vpc_id = module.create-vpc.vpc-id
  locked-down-ip-addresses = [ #update this value
    "99.44.98.252/32",
  ]
}

module "create-vulnerable-web-app" {
  source            = ".//modules//vulnerable-web-app"
  name              = "vulnerable-web-app"
  instance_type     = "t2.micro"
  public_subnet_id  = module.create-vpc.public-subnet-1-id
  security_group_id = module.create-security-group.web-security-group-id
  vpc_id            = module.create-vpc.vpc-id
}

#####################################
# Outputs
#####################################

output "ec2_public_dns" {
  value = module.create-vulnerable-web-app.public_dns
}