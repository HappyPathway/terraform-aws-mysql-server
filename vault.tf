locals {
  db = {
    "user" = "${random_string.username.result}"
    "passwd" = "${random_string.password.result}"
    "host" = "${aws_db_instance.default.endpoint}"
    "db" = "${var.db_name}"
    }
}

resource "vault_mount" "db" {
  path                      = "${var.service_name}/db-${var.db_name}"
  type                      = "database"
  max_lease_ttl_seconds     = "${var.max_ttl}"
  default_lease_ttl_seconds = "${var.default_ttl}"
}

resource "vault_database_secret_backend_connection" "mysql" {
  backend       = "${vault_mount.db.path}"
  name          = "${var.db_name}"
  allowed_roles = ["mysql_crud", "mysql_ro"]

  mysql {
    connection_url = "${local.db["user"]}:${local.db["passwd"]}@tcp(${local.db["host"]})/${local.db["db"]}"
  }
}

resource "vault_database_secret_backend_role" "mysql_crud" {
  backend             = "${vault_mount.db.path}"
  name                = "mysql_crud"
  db_name             = "${var.db_name}"
  creation_statements = "${file("${path.module}/vault_policy_templates/mysql_crud.sql")}"
  default_ttl         = "${var.default_ttl}"
  max_ttl             = "${var.max_ttl}"
}

resource "vault_database_secret_backend_role" "mysql_ro" {
  backend             = "${vault_mount.db.path}"
  name                = "mysql_ro"
  db_name             = "${var.db_name}"
  creation_statements = "${file("${path.module}/vault_policy_templates/mysql_ro.sql")}"
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
