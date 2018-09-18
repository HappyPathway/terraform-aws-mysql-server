resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "${var.service_name}-${var.db_name}" 
  name                 = "${var.db_name}"
  username             = "${random_string.username.result}"
  password             = "${random_string.password.result}"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  skip_final_snapshot = true
}

data "template_file" "credentials" {
  template = "${file("${path.module}/vault_policy_templates/vault_credentials.json.tpl")}"

  vars {
    username = "${random_string.username.result}"
    password = "${random_string.password.result}"
  }
}

resource "vault_generic_secret" "credentials" {
  path      = "${var.service_name}/secrets/credentials/database/${var.db_name}"
  data_json = "${data.template_file.credentials.rendered}"
}
