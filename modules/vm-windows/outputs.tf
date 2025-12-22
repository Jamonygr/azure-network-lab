output "id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.this.id
}

output "name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.this.name
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.this.private_ip_address
}

output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.this.id
}
