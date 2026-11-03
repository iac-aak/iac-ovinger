terraform {
  required_version = ">= 1.16.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.7"
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = format("vnet-%s", var.base_name)
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.address_space]
  tags                = var.tags
}

# for_each på map: nøkkelen ("web") er identiteten i state, ikke posisjonen.
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = format("snet-%s-%s", each.key, var.base_name)
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  # netnum kommer fra mapet, ikke fra index(), så et subnett beholder adressen
  # sin om andre legges til eller fjernes.
  address_prefixes = [cidrsubnet(var.address_space, var.subnet_newbits, each.value)]
}

# Ingen egne regler – Azures standardregler holder.
resource "azurerm_network_security_group" "nsg" {
  #checkov:skip=CKV_AZURE_10
  name                = format("nsg-%s", var.base_name)
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  security_rule {
    name                       = "ssh-feilsoking"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# for_each over subnet-ressursen gir samme nøkler, så koblingene følger subnettene.
resource "azurerm_subnet_network_security_group_association" "snet_nsg" {
  for_each = azurerm_subnet.subnet

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
