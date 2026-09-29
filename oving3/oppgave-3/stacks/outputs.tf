# =============================================================================
#  stacks/outputs.tf
# -----------------------------------------------------------------------------
#  Verdier må sendes videre lag for lag. En output i en child module er ikke
#  synlig for den som kaller root-modulen – hvert lag må gi den fra seg selv.
#  Det føles dobbelt opp, og det er prisen for at lagene er frittstående.
# =============================================================================

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "Subnet-ID per subnettnavn."
}

output "subnet_prefixes" {
  value       = module.network.subnet_prefixes
  description = "Utregnet adresseprefiks per subnettnavn."
}

output "vnet_name" {
  value       = module.network.vnet_name
  description = "Navnet på det virtuelle nettverket."
}

output "vm_name" {
  value       = module.compute.vm_name
  description = "Navnet på den virtuelle maskinen."
}

output "vm_private_ip" {
  value       = module.compute.private_ip_address
  description = "Maskinens private IP-adresse."
}