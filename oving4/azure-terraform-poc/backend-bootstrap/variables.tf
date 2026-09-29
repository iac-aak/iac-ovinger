variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "aak"
}

variable "sc_name" {
  type        = string
  description = "Storage container name"
  default     = "tfstate"
}

