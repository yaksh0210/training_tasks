output "instance_ids" {
  value = aws_instance.yaksh_app[*].id
}