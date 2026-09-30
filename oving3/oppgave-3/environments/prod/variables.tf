variable "name_prefix" {
  type        = string
  description = "Personlig kortnavn (aak), så vi ikke kolliderer med andre studenter i tenanten."
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

  validation {
    condition = contains([
      "northeurope", "uksouth", "westeurope", "norwayeast", "norwaywest",
    ], var.location)
    error_message = "Regionen er ikke tillatt i tenanten."
  }
}

variable "address_space" {
  type        = string
  description = "Miljøets adresserom, f.eks. 10.162.0.0/16."
}

variable "subnets" {
  type        = map(number)
  description = "Subnett: navn => netnum."
}

variable "vm_subnet_key" {
  type        = string
  default     = "app"
  description = "Nøkkel i subnets for subnettet VM-en havner i."
}

variable "vm_size" {
  type        = string
  description = "VM-SKU."
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Admin-bruker på VM-en."
}

variable "ssh_public_key" {
  type        = string
  description = "Offentlig SSH-nøkkel."
}

variable "subscription_id" {
  type        = string
  default     = null
  description = "Subscription-ID. Null gir ARM_SUBSCRIPTION_ID eller aktiv az-subscription."
}
