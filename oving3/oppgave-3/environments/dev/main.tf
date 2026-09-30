# Identisk i dev, test og prod (K1). Forskjellene ligger i terraform.tfvars.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  base_name = lower(format("%s-%s", var.environment, var.name_prefix))

  # Tags arves ikke fra ressursgruppa, så de sendes nedover.
  common_tags = {
    environment = var.environment
    owner       = var.owner
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s", local.base_name)
  location = var.location
  tags     = local.common_tags
}

module "stack" {
  source = "../../stacks"

  rg_name   = azurerm_resource_group.rg.name
  location  = var.location
  base_name = local.base_name
  tags      = local.common_tags

  address_space  = var.address_space
  subnets        = var.subnets
  vm_size        = var.vm_size
  vm_subnet_key  = var.vm_subnet_key
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
}
