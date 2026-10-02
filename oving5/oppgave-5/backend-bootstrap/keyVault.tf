resource "azurerm_key_vault" "kv" {
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

output "keyvault_name" {
  value = azurerm_key_vault.kv.name
}