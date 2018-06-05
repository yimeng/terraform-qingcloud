variable "access_key" {
  default = "access_key_value"
}

variable "secret_key" {
  default = "secret_key_value"
}

variable "zone" {
  default = "pek3"
}

provider "qingcloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  zone = "${var.zone}"
}
