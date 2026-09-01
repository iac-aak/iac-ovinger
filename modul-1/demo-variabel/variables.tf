variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "West Europe"
}

variable "rgname" {
  description = "The name of the resource group"
  type        = string
}

variable "saname" {
  description = "The name of the storage account"
  type        = string
}

variable "company" {
  type        = string
  description = "Company name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "billing_code" {
  type        = string
  description = "Billing code - identifies which department is charged"
}