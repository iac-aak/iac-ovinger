output "subnet_id" {
  description = "ID til subnettet VM-en skal kobles til (styrt av var.vm_subnet_key)."
  value       = azurerm_subnet.subnet[var.vm_subnet_key].id
}

output "subnet_ids" {
  description = "Map fra subnett-navn (nøkkel i var.subnets) til subnett-ID."
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID-en til det virtuelle nettverket – trengs for peering"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Navnet på det virtuelle nettverket"
}

