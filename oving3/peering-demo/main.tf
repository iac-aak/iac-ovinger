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

locals {
  rg_name = lower(format("rg-%s-%s", var.environment, var.name_prefix))
  common_tags = {
    environment = var.environment
    owner       = var.owner
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

module "hub" {
  source = "./modules/network"

  rg_name       = azurerm_resource_group.rg.name
  location      = var.location
  vnet_name     = "vnet-hub"
  address_space = "10.0.0.0/16"
}

module "spoke" {
  source = "./modules/network"

  rg_name       = azurerm_resource_group.rg.name
  location      = var.location
  vnet_name     = "vnet-spoke"
  address_space = "10.10.0.0/16"
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = module.spoke.vnet_name
  remote_virtual_network_id = module.hub.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
}
