# Consumer stack: leser nettverkets subnett-ID fra remote state og lager VM-en.

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
    "Microsoft.Compute",
  ]
}

locals {
  base_name = lower(format("%s-%s", var.environment, var.name_prefix))

  common_tags = {
    environment = var.environment
    owner       = var.owner
    stack       = "app"
    managedby   = "terraform"
  }
}

# Leser den ANDRE stackens state. key peker på nettverk, ikke på app.
data "terraform_remote_state" "nettverk" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.tfstate_resource_group
    storage_account_name = var.tfstate_storage_account
    container_name       = "tfstate"
    key                  = "${var.environment}/nettverk.tfstate"
    use_azuread_auth     = true
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-app-%s", local.base_name)
  location = var.location
  tags     = local.common_tags
}

module "compute" {
  source = "../../../modules/compute"

  rg_name        = azurerm_resource_group.rg.name
  location       = var.location
  base_name      = local.base_name
  vm_size        = var.vm_size
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  tags           = local.common_tags

  subnet_id = data.terraform_remote_state.nettverk.outputs.subnet_ids[var.vm_subnet_key]
}
