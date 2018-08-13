resource "vault_mount" "db" {
  path                      = "${var.service_name}/db-${var.db_name}"
  type                      = "database"
  max_lease_ttl_seconds     = "${var.max_ttl}"
  default_lease_ttl_seconds = "${var.default_ttl}"
}

data "template_file" "vault_backend_connection" {
  template = "${file("${path.module}/vault_policy_templates/database_connection.json.tpl")}"

  vars = {
    db_endpoint = "${aws_db_instance.default.endpoint}"
    db_name        = "${var.db_name}"
    username       = "${random_string.username.result}"
    password       = "${random_string.password.result}"
  }
}

resource "vault_database_secret_backend_connection" "mysql" {
  backend       = "${vault_mount.db.path}"
  name          = "${var.db_name}"
  allowed_roles = ["mysql_crud", "mysql_ro"]

  mysql {
    connection_url = "${random_string.username.result}:${random_string.password.result}@tcp(${aws_db_instance.default.endpoint})/${var.db_name}"
  }
}

resource "vault_database_secret_backend_role" "mysql_crud" {
  backend             = "${vault_mount.db.path}"
  name                = "mysql_crud"
  db_name             = "${var.db_name}"
  creation_statements = "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT ALTER, CREATE ON ${var.db_name} to '{{name}}'@'%'; grant CREATE,DROP,SELECT,INSERT,UPDATE,DELETE on ${var.db_name}.* to '{{name}}'@'%'; flush privileges"
  default_ttl         = "${var.default_ttl}"
  max_ttl             = "${var.max_ttl}"
}

resource "vault_database_secret_backend_role" "mysql_ro" {
  backend             = "${vault_mount.db.path}"
  name                = "mysql_ro"
  db_name             = "${var.db_name}"
  creation_statements = "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; grant SELECT on ${var.db_name}.* to '{{name}}'@'%'; flush privileges"
  default_ttl         = "${var.default_ttl}"
  max_ttl             = "${var.max_ttl}"
}

output "vault_mount" {
  value = "${vault_mount.db.path}"
}

output "mysql_crud" {
  value = "${var.service_name}/db-${var.db_name}/creds/mysql_crud"
}

output "mysql_ro" {
  value = "${var.service_name}/db-${var.db_name}/creds/mysql_ro"
}