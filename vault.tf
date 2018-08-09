data "template_file" "credentials" {
  template = "${file("${path.module}/vault_credentials.json.tpl")}"

  vars {
    username = "${random_string.username.result}"
    password = "${random_string.password.result}"
  }
}

resource "vault_generic_secret" "credentials" {
  path      = "${var.service_name}/credentials/database/${var.db_name}"
  data_json = "${data.template_file.credentials.rendered}"
}

resource "vault_mount" "db" {
  path                      = "${var.service_name}/db-${var.db_name}"
  type                      = "database"
  max_lease_ttl_seconds     = "${var.max_ttl}"
  default_lease_ttl_seconds = "${var.default_ttl}"
}

data "template_file" "vault_backend_connection" {
  template = "${file("${path.module}/database_connection.json.tpl")}"

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

# CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';

data "template_file" "mysql_ro" {
  template = "${file("${path.module}/vault_policy_templates/mysql_ro.hcl.tpl")}"

  vars {
    db_name = "${var.db_name}"
    service_name = "${var.service_name}"
  }
}

resource "vault_policy" "mysql_ro" {
  name   = "${var.service_name}-${var.db_name}-mysql_ro"
  policy = "${data.template_file.mysql_ro.rendered}"
}

data "template_file" "mysql_crud" {
  template = "${file("${path.module}/vault_policy_templates/mysql_crud.hcl.tpl")}"

  vars {
    db_name = "${var.db_name}"
    service_name = "${var.service_name}"
  }
}

resource "vault_policy" "mysql_crud" {
  name   = "${var.service_name}-${var.db_name}-mysql_crud"
  policy = "${data.template_file.mysql_crud.rendered}"
}

data "template_file" "db_credentials" {
  template = "${file("${path.module}/vault_policy_templates/db_credentials.tpl")}"

  vars {
    service_name = "${var.service_name}"
    db_name = "${var.db_name}"
  }
}

resource "vault_policy" "db_credentials" {
  name = "${var.service_name}-${var.db_name}-credentials"
  policy = "${data.template_file.mysql_crud.rendered}"
}