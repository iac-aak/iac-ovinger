output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID-en til det virtuelle nettverket – trengs for peering"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Navnet på det virtuelle nettverket"
}
