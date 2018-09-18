output "endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "host" {
  value = "${aws_db_instance.default.address}"
}

output "service_name" {
  value = "${var.service_name}"
}

output "address" {
  value = "${aws_db_instance.default.endpoint}"
}

output "port" {
  value = "${aws_db_instance.default.port}"
}

output "db_name" {
  value = "${var.db_name}"
}

output "db_identifier" {
  value = "${aws_db_instance.default.identifier}"
}
