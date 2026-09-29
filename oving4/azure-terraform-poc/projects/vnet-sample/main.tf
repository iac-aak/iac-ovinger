provider "azurerm" {
  features {}
  resource_providers_to_register = [
    "Microsoft.Network",
  ]
  use_cli = true
}

locals {
  common_tags = {
    environment = var.environment
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "lab" {
  name     =  lower(format("rg-%s-%s", var.environment, var.prefix))

  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = lower(format("vnet-%s-%s", var.environment, var.prefix))
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = var.address_space
}

