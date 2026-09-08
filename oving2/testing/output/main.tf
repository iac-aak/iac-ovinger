terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "demo" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}

output "sa_id" {
  value = azurerm_storage_account.demo.id
}