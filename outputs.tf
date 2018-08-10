output "endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "db_name" {
  value = "${var.db_name}"
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