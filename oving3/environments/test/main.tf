terraform {
  required_version = ">= 1.6"
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40.0"
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
  tags     = merge(var.tags, local.common_tags)
}

module "stack" {
  source             = "../../stacks"
  rg_name            = azurerm_resource_group.rg.name
  location           = var.location
  environment        = var.environment
  name_prefix        = var.name_prefix
  vnet_cidr          = var.vnet_cidr
  allow_ssh_cidr     = var.allow_ssh_cidr
  vm_size            = var.vm_size
  admin_username     = var.admin_username
  ssh_public_key     = var.ssh_public_key
  allocate_public_ip = var.allocate_public_ip
  tags               = merge(var.tags, local.common_tags)
  vm_subnet_key      = var.vm_subnet_key

}
