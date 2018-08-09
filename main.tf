resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "${var.db_name}"
  username             = "${random_string.username.result}"
  password             = "${random_string.password.result}"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
}