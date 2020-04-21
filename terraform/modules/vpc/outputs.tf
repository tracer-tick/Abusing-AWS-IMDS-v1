output "public-subnet-1-id" {
  value = aws_subnet.aws_subnet_public[0].id
}

output "subnets" {
  value = [aws_subnet.aws_subnet_public[0].id, aws_subnet.aws_subnet_public[1].id]
}

output "vpc-id" {
  value = aws_vpc.vpc.id
}