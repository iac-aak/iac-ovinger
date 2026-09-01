variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "West Europe"
}

variable "prefix" {
  description = "Short name/initials for the owner or team, used as a prefix in resource names"
  type        = string
}

variable "project" {
  description = "Project name - used in resource names and as the 'project' tag"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, test, prod)"
  type        = string
}

variable "owner" {
  description = "Owner of the resources (e-mail), used as the 'owner' tag"
  type        = string
}

variable "costcenter" {
  description = "Cost center - identifies which department is charged"
  type        = string
}
