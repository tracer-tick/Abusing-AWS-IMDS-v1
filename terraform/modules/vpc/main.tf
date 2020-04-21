resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name,
  }
}

resource "aws_subnet" "aws_subnet_public" {
  count = var.num_public_subnets

  availability_zone       = data.aws_availability_zones.az.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name = "public-subnet-${count.index + 1}",
    vpc  = var.vpc_name,
  }
}

resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.aws_internet_gateway_name,
    vpc  = var.vpc_name,
  }
}

# Routing #
resource "aws_route_table" "aws_route_table_public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.aws_route_table_public_name,
    vpc  = var.vpc_name,
  }
}

resource "aws_main_route_table_association" "aws_main_route_table_association" {
  route_table_id = aws_route_table.aws_route_table_public.id
  vpc_id         = aws_vpc.vpc.id
}

resource "aws_route" "aws_routep_public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_internet_gateway.id
  route_table_id         = aws_route_table.aws_route_table_public.id
}

resource "aws_route_table_association" "aws_route_table_association_public" {
  count = var.num_public_subnets

  route_table_id = aws_route_table.aws_route_table_public.id
  subnet_id      = aws_subnet.aws_subnet_public[count.index].id
}
