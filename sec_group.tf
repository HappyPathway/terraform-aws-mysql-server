resource "random_uuid" "uuid" { }

resource "aws_security_group" "db" {
  name        = "allow_all-${var.service_name}-${random_uuid.uuid.result}"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.source_cidr}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "db_sec_group" {
  value = "allow_all-${var.service_name}-${random_uuid.uuid.result}"
}
