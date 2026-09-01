resource "azurerm_resource_group" "demo" {
  name     = "rg-${var.base_name}"
  location = var.location
}