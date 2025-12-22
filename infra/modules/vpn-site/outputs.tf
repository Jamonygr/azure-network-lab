output "id" {
  description = "ID of the VPN Site"
  value       = azurerm_vpn_site.this.id
}

output "name" {
  description = "Name of the VPN Site"
  value       = azurerm_vpn_site.this.name
}

output "connection_id" {
  description = "ID of the VPN Gateway Connection"
  value       = azurerm_vpn_gateway_connection.this.id
}
