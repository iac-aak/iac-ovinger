variable "rg_name" {
  type        = string
  description = "Navn på ressursgruppa. Kommer fra Key Vault i workflowen."
}

variable "location" {
  type        = string
  description = "Azure-region. Kommer fra Key Vault i workflowen."
}
