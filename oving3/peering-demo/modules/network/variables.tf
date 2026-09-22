variable "rg_name" {
  type        = string
  description = "Navn på Resource Group der nettverksressurser skal opprettes."
}

variable "location" {
  type        = string
  description = "Azure-region (må samsvare med RG)."
}

variable "vnet_name" {
  type        = string
  description = "Navn på det virtuelle nettverket."
}

variable "address_space" {
  type        = string
  description = "Adresserom for VNet."
}
