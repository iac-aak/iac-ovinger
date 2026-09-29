# =============================================================================
#  environments/<miljø>/outputs.tf
# -----------------------------------------------------------------------------
#  Verdier må sendes videre lag for lag: modules -> stacks -> environments.
#  Herfra er det module.stack som gjelder – module.network og module.compute
#  ligger ett lag lenger ned og er ikke synlige her.
# =============================================================================

output "resource_group" {
  value       = azurerm_resource_group.rg.name
  description = "Ressursgruppa miljøet har opprettet."
}

output "subnet_ids" {
  value       = module.stack.subnet_ids
  description = "Subnet-ID per subnettnavn."
}

output "subnet_prefixes" {
  value       = module.stack.subnet_prefixes
  description = "Utregnet adresseprefiks per subnettnavn."
}

output "vnet_name" {
  value       = module.stack.vnet_name
  description = "Navnet på det virtuelle nettverket."
}

output "vm_name" {
  value       = module.stack.vm_name
  description = "Navnet på den virtuelle maskinen."
}

output "vm_private_ip" {
  value       = module.stack.vm_private_ip
  description = "Maskinens private IP-adresse."
}
