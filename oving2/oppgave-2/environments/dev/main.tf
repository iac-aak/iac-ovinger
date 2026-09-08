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
  rg_name = format(lower("rg-%s-%s"), var.environment, var.name_prefix)
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

module "network" {
  source      = "../../modules/network"
  rg_name     = azurerm_resource_group.rg.name
  location    = var.location
  environment = var.environment
  name_prefix = var.name_prefix
  vnet_cidr   = var.vnet_cidr
  subnet_cidr = var.subnet_cidr
  tags        = local.common_tags
}

module "compute" {
  source         = "../../modules/compute"
  rg_name        = azurerm_resource_group.rg.name
  location       = var.location
  environment    = var.environment
  name_prefix    = var.name_prefix
  subnet_id      = module.network.subnet_id
  vm_size        = var.vm_size
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  tags           = local.common_tags

}
