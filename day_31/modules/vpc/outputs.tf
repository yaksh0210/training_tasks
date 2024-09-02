output "vpc_id" {
  value = aws_vpc.yaksh_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.yaksh_public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.yaksh_private[*].id
}