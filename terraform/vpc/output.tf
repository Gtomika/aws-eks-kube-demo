output "subnet_ids" {
  value = aws_subnet.demo_subnets[*].id
}