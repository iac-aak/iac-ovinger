variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "West Europe"
}

variable "rgname" {
  description = "The name of the resource group"
  type        = string
  # default     = "rg-demo-aak"
}

variable "saname" {
  description = "The name of the storage account"
  type        = string
  # default     = "stdemoaak"
}