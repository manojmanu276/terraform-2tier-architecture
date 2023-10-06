resource "aws_db_subnet_group" "db-subnet" {
  name       = var.db_sub_name
  subnet_ids = [var.prv_sub_5a_id, var.prv_sub_6b_id]

}

resource "aws_db_instance" "db" {
  identifier              = "mydb-instance"
  allocated_storage       = 20
  db_name                 = var.db_name
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.mysql5.7"
  multi_az                = true
  storage_type            = "gp2"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0
  vpc_security_group_ids  = [var.db_sg_id] # Replace with your desired security group ID

  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
  tags = {
    Name = "mydb"
  }
}
