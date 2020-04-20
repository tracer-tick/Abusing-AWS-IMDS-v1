# Modules Description #
# This module creates a VPC with 2 public subnets. There is a public route table associated with the VPC
# with which both subnets are associated. An internet gateway is attached to the VPC.

# Resources #
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = var.vpc_name,
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.az.names[count.index]

  tags = {
    name = "public-subnet-${count.index + 1}",
    vpc  = var.vpc_name,
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    name = "igw",
    vpc  = var.vpc_name,
  }
}

# Routing #
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    name = "public-route-table",
    vpc  = var.vpc_name,
  }
}

resource "aws_main_route_table_association" "main_rt" {
  route_table_id = aws_route_table.public_rt.id
  vpc_id         = aws_vpc.vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rta" {
  count = 2

  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}
