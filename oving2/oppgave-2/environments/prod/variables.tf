variable "environment" { type = string }
variable "location" { type = string }
variable "owner" { type = string }
variable "name_prefix" {
  type    = string
  default = "demo"
}

variable "vnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}
variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "ssh_public_key" { type = string }
