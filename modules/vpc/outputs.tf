output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "public-subnet-1-id" {
  value = aws_subnet.public_subnet[0].id
}