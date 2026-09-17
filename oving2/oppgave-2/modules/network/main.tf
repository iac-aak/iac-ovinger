resource "azurerm_virtual_network" "vnet" {
  name                = lower(format("vnet-%s-%s", var.environment, var.name_prefix))
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = lower(format("snet-%s-%s", var.environment, var.name_prefix))
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}


