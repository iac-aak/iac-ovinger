variable "environment" { type = string }
variable "location" { type = string }
variable "name_prefix" {
  type    = string
  default = "demo"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "owner" {
  type        = string
  description = "Eier av ressursene i miljøet."
}
