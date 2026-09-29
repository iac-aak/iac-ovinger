output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "Subnet-ID per subnettnavn."
}

output "subnet_prefixes" {
  value       = module.network.subnet_prefixes
  description = "Adresseprefiks per subnettnavn."
}

output "vnet_name" {
  value       = module.network.vnet_name
  description = "Navnet på vnet."
}

output "vm_name" {
  value       = module.compute.vm_name
  description = "VM-navn."
}

output "vm_private_ip" {
  value       = module.compute.private_ip_address
  description = "VM-ens private IP."
}
