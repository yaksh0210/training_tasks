resource "aws_db_instance" "yaksh_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name                 = "yakshdb"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.yaksh_db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.yaksh_db_subnet_group.name
  skip_final_snapshot  = true

  tags = {
    Name = "yaksh-db-instance"
  }
  #lifecycle {
  #  prevent_destroy = true
  #}
}

resource "aws_db_subnet_group" "yaksh_db_subnet_group" {
  name       = "yaksh-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "yaksh-db-subnet-group"
  }
}

resource "aws_security_group" "yaksh_db_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "yaksh-db-sg"
  }
}