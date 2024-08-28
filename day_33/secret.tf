resource "aws_secretsmanager_secret" "yaksh_db_secret" {
  name = "yaksh_db_secret3"
}

resource "aws_secretsmanager_secret_version" "yaksh_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.yaksh_db_secret.id
  secret_string = jsonencode({
    password = var.db_password
  })
}