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

variable "tfstate_resource_group" {
  type        = string
  description = "Ressursgruppa med state-kontoen (samme som i shared/backend.hcl)."
}

variable "tfstate_storage_account" {
  type        = string
  description = "State-kontoen (samme som i shared/backend.hcl)."
}

variable "vm_subnet_key" {
  type        = string
  default     = "app"
  description = "Nøkkel i nettverkets subnet_ids for subnettet VM-en havner i."
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
