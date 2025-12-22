output "id" {
  description = "ID of the VPN Connection"
  value       = azurerm_virtual_network_gateway_connection.this.id
}

output "name" {
  description = "Name of the VPN Connection"
  value       = azurerm_virtual_network_gateway_connection.this.name
}
