data "aws_secretsmanager_secret" "password" {
  name = "test-db-password"
}

data "aws_secretsmanager_secret_version" "password" {
  secret_id = data.aws_secretsmanager_secret.password.id
}


resource "aws_db_subnet_group" "test_subnet_group" {
  name = "test_subnet_group"
  subnet_ids = [
    aws_subnet.subnet1-public.id,
    aws_subnet.subnet2-public.id,
  ]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "test_db_instance" {
  identifier           = "testdb"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.39"
  instance_class       = "db.t3.medium"
  db_name              = "mydb"
  username             = "dbadmin"
  password             = data.aws_secretsmanager_secret_version.password.secret_string
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.test_subnet_group.id
}
