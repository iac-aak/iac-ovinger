# Provider stack: lager nettverket og publiserer subnett-ID-ene (se outputs.tf).

terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.7"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

  # Fra azurerm 5.0 registreres ingen resource providers automatisk.
  resource_providers_to_register = [
    "Microsoft.Network",
  ]
}

locals {
  base_name = lower(format("%s-%s", var.environment, var.name_prefix))

  common_tags = {
    environment = var.environment
    owner       = var.owner
    stack       = "nettverk"
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-nettverk-%s", local.base_name)
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "../../../modules/network"

  rg_name       = azurerm_resource_group.rg.name
  location      = var.location
  base_name     = local.base_name
  address_space = var.address_space
  subnets       = var.subnets
  tags          = local.common_tags
}
