provider "azurerm" {
  features {
  }
  resource_providers_to_register = [
    "Microsoft.Storage",
    "Microsoft.Authorization",
  ]
  storage_use_azuread = true
  use_cli             = true
}


data "azurerm_client_config" "current" {}

locals {
  common_tags = {
    environment = var.environment
    owner       = data.azurerm_client_config.current.object_id
    managedby   = "terraform"

  }
}

resource "azurerm_resource_group" "rg" {
  name     = lower(format("rg-%s-%s", var.environment, var.prefix))
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "sa" {
  name                            = lower(format("sa%s%s", var.environment, var.prefix)) # må være globalt unikt
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = merge(local.common_tags, {
    purpose = "terraform-backend"
  })
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.sc_name
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

# Tildel data-rolle til innlogget bruker på STORAGE-KONTO-nivå
# Dette dekker både listing av containere og listing/lesing/skriving av blobs.
resource "azurerm_role_assignment" "blob_contrib_self_account_scope" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"

  # Sørg for at kontoen er ferdig opprettet før RBAC forsøkes
  depends_on = [
    azurerm_storage_account.sa,
    azurerm_storage_container.tfstate
  ]
}
