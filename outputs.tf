output "endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "db_name" {
  value = "${var.db_name}"
}

output "vault_mount" {
  value = "${vault_mount.db.path}"
}
