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


variable "address_space" {
  type        = list(string)
  description = "CIDR for VNet"
  default     = ["10.42.0.0/16"]
}