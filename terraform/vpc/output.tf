output "public_subnet_ids" {
  value = aws_subnet.demo_public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.demo_private_subnets[*].id
}