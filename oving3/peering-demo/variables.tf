variable "location" {
  type        = string
  description = "Azure-region (må samsvare med RG)."
}

variable "environment" {
  type        = string
  description = "Miljønavn (dev, test, prod)."
}

variable "name_prefix" {
  type        = string
  description = "Navneprefix for nettverksressurser."
  default     = "demo"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Ekstra tags."
}

variable "owner" {
  type        = string
  description = "Eier av ressursene."
}
