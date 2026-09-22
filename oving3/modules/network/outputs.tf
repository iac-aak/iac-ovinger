output "subnet_ids" {
  description = "Map fra subnett-navn (nøkkel i var.subnets) til subnett-ID."
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
}

output "vnet_name" {
  description = "Navn på VNet."
  value       = azurerm_virtual_network.vnet.name
}


