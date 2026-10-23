# Grensesnittet ut: bare root-outputs er synlige for terraform_remote_state.
# Verdier fra modulen må eksporteres videre herfra.

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "Subnet-ID per subnettnavn. Leses av app-stacken."
}

output "vnet_name" {
  value       = module.network.vnet_name
  description = "Navnet på det virtuelle nettverket."
}
