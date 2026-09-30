variable "shortname" {
  type        = string
  description = "Personlig kortnavn, brukes i navn på ressurser (globalt unikt storage account)."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure-region."
}

variable "container_name" {
  type        = string
  default     = "tfstate"
  description = "Navn på containeren som holder state-filene."
}

variable "subscription_id" {
  type        = string
  default     = null
  description = "Subscription-ID. Null gir ARM_SUBSCRIPTION_ID eller aktiv az-subscription."
}
