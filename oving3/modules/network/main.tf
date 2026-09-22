resource "azurerm_virtual_network" "vnet" {
  name                = lower(format("vnet-%s-%s", var.environment, var.name_prefix))
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = lower(format("snet-%s-%s", each.key, var.name_prefix))
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [cidrsubnet(var.vnet_cidr, 8, each.value)]
}

resource "azurerm_network_security_group" "nsg" {
  name                = lower(format("nsg-%s-%s", var.environment, var.name_prefix))
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.allow_ssh_cidr == null ? [] : [var.allow_ssh_cidr]
    content {
      name                       = "allow-ssh-inbound"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = security_rule.value
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each = azurerm_subnet.subnet

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
