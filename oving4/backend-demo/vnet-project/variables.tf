variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-network-aak"
}

variable "vnet_name" {
  description = "VNet name"
  type        = string
  default     = "vnet-network-aak"
}

variable "address_space" {
  description = "CIDR for VNet"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}
