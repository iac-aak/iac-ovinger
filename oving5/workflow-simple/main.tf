terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
  }
}

provider "azurerm" {
  features {}

  resource_providers_to_register = ["Microsoft.Storage"]
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}