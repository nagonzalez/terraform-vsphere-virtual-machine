variable "count" {
  default = 1
}

variable "cluster" {}

variable "data_size_gb" {
  default = "0"
}

variable "datacenter" {}
variable "datastore" {}

variable "domain" {
  default = ""
}

variable "folder" {}
variable "guest_id" {}
variable "memory" {}
variable "network" {}
variable "num_cpus" {}
variable "os_type" {}
variable "os_type_category_id" {}
variable "role_category_id" {}
variable "role" {}
variable "template" {}

variable "workgroup" {
  default = ""
}

variable "netmask" {
  default = ""
}

variable "ips" {
  type    = "list"
  default = []
}

variable "dns_server_list" {
  type    = "list"
  default = []
}

variable "gateway" {
  default = ""
}
