# tflint-ignore: azurerm_resources_missing_prevent_destroy # Key Vault-et har soft delete og kan gjenopprettes
resource "azurerm_key_vault" "kv" {
  #checkov:skip=CKV_AZURE_110:Purge protection hindrer opprydding i et studentoppsett
  #checkov:skip=CKV_AZURE_42:Krever purge protection, se CKV_AZURE_110
  #checkov:skip=CKV_AZURE_189:GitHub-runneren henter parameterfila fra Key Vault over internett
  #checkov:skip=CKV_AZURE_109:Samme grunn som CKV_AZURE_189: runneren har ingen fast IP
  #checkov:skip=CKV2_AZURE_32:Private endpoint krever et privat nettverk runneren er koblet til, utenfor faget
  name                = substr(lower("kv-tf-${var.shortname}"), 0, 24)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = local.tags
}

# Du skal kunne SKRIVE secrets — det er du som laster opp parameterverdiene.
resource "azurerm_role_assignment" "kv_officer_meg" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"
}

# Workflowen skal bare LESE parameterverdier, ikke skrive dem.
resource "azurerm_role_assignment" "kv_user_pipeline" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.pipeline_principal_id
  principal_type       = "ServicePrincipal"
}

output "keyvault_name" {
  description = "Navnet på Key Vault-et som lagrer parameterverdiene (tfvars-secrets)."
  value       = azurerm_key_vault.kv.name
}