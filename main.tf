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
# Data
#####################################

data "aws_availability_zones" "az" {}

#########terr############################
# Modules
#####################################

module "create-vpc" {
  # realize there's a module to do this on TF registry but want to write my own
  source         = ".//modules//vpc"
  vpc_name       = "imds-custom-vpc"
  vpc_cidr_block = "192.168.0.0/16"
}