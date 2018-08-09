variable "service_name" {}

variable "db_name" {}

variable "max_ttl" {
  default = "90"
}

variable "default_ttl" {
  default = "30"
}

variable "source_cidr" {
  default = "0.0.0.0/0"
}
