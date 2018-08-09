resource "random_string" "username" {
  length  = 16
  special = false
  number  = false
  upper   = false
}

resource "random_string" "password" {
  length  = 16
  special = false
}
