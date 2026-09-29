terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_cli = true # Bruker pålogging via `az login`
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


# Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = lower(format("sa%s%s", var.environment, var.name_prefix)) # må være globalt unikt
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }
}

# Resource lock: hindrer utilsiktet sletting av backend-storagekontoen
# (denne holder Terraform state for hele oppsettet)
resource "azurerm_management_lock" "sa_lock" {
  name       = "CanNotDelete-${azurerm_storage_account.sa.name}"
  scope      = azurerm_storage_account.sa.id
  lock_level = "CanNotDelete"
  notes      = "Beskytter backend storage account (Terraform state) mot sletting."
}

# Container for state files
resource "azurerm_storage_container" "sc" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

# Hent innlogget bruker fra Entra ID
data "azurerm_client_config" "current" {}

# Tilgang slik at innlogget bruker kan liste innholdet i containeren
resource "azurerm_role_assignment" "blob_reader" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azurerm_client_config.current.object_id

  # Sørg for at SA og Container er ferdig opprettet før RBAC forsøkes
  depends_on = [
    azurerm_storage_account.sa,
    azurerm_storage_container.sc
  ]
}