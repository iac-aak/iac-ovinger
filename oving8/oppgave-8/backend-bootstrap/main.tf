# Bootstrap-stack for state-backend og Key Vault (keyVault.tf). Ingen backend-blokk: state er lokal.
# Rolletildelinger til pipeline-identiteten (K4) ligger her og i keyVault.tf.

provider "azurerm" {
  features {}

  resource_providers_to_register = [
    "Microsoft.Storage",
    "Microsoft.Authorization",
    "Microsoft.KeyVault",
  ]
  storage_use_azuread = true
}

data "azurerm_client_config" "current" {}

locals {
  tags = {
    keep      = "true" # freder ressursgruppa mot nattlig sletting
    purpose   = "terraform-backend"
    owner     = var.shortname
    managedby = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-tfstate-%s", var.shortname)
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "sa" {
  #checkov:skip=CKV_AZURE_59:GitHub-runneren når state over internett, stenges tilgangen stenges også pipelinen
  #checkov:skip=CKV_AZURE_206:GRS koster omtrent det dobbelte, state er beskyttet av versjonering og soft delete
  #checkov:skip=CKV_AZURE_33:Storage account-et brukes ikke til køer
  #checkov:skip=CKV_AZURE_43:Navnet bygges av format() og var.shortname som Checkov ikke evaluerer, resultatet satfstateaak oppfyller reglene
  #checkov:skip=CKV2_AZURE_33:Private endpoint krever et privat nettverk runneren er koblet til, utenfor faget
  #checkov:skip=CKV2_AZURE_1:Azure krypterer allerede med Microsoft-administrerte nøkler, egen nøkkel er ikke et krav her
  name                            = lower(format("satfstate%s", var.shortname)) # globalt unikt
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = false # kun Entra ID-tilgang
  default_to_oauth_authentication = true
  allow_nested_items_to_be_public = false

  blob_properties { # versjonering og soft delete på state
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
  lifecycle {
    prevent_destroy = true
  }

  tags = local.tags
}

resource "azurerm_storage_container" "tfstate" {
  #checkov:skip=CKV2_AZURE_21:Lese-logging koster lagring og oppsett, et godt tiltak å rette i et ekte oppsett
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_role_assignment" "blob_contributor" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"
}

resource "azurerm_role_assignment" "pipeline_blob_contributor" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pipeline_principal_id
  principal_type       = "ServicePrincipal"

  depends_on = [
    azurerm_storage_account.sa,
    azurerm_storage_container.tfstate
  ]
}