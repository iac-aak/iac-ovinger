variable "name_prefix" {
  type        = string
  description = "Personlig kortnavn (aak)."
}

variable "owner" {
  type        = string
  description = "Eier (e-post), brukes i tags."
}

variable "environment" {
  type        = string
  description = "dev, test eller prod."

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment må være dev, test eller prod."
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure-region."
}

variable "sku" {
  type        = string
  default     = "B1"
  description = "App Service-plan SKU."
}

variable "node_version" {
  type        = string
  default     = "22-lts"
  description = "Node-versjon for web app-en."
}
