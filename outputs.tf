output "endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "service_name" {
  value = "${var.service_name}"
}

output "address" {
  value = "${aws_db_instance.default.endpoint}"
}

output "db_name" {
  value = "${var.db_name}"
}
