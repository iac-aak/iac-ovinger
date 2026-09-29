output "resource_group" {
  value       = azurerm_resource_group.rg.name
  description = "Ressursgruppa."
}

output "subnet_ids" {
  value       = module.stack.subnet_ids
  description = "Subnet-ID per subnettnavn."
}

output "subnet_prefixes" {
  value       = module.stack.subnet_prefixes
  description = "Adresseprefiks per subnettnavn."
}

output "vnet_name" {
  value       = module.stack.vnet_name
  description = "Navnet på vnet."
}

output "vm_name" {
  value       = module.stack.vm_name
  description = "VM-navn."
}

output "vm_private_ip" {
  value       = module.stack.vm_private_ip
  description = "VM-ens private IP."
}
