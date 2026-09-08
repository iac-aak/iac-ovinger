output "vm_id" {
  description = "Ressurs-ID for VM."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "private_ip" {
  description = "Privat IP for VM."
  value       = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

