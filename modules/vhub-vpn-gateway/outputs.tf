output "id" {
  description = "ID of the VPN Gateway"
  value       = azurerm_vpn_gateway.this.id
}

output "name" {
  description = "Name of the VPN Gateway"
  value       = azurerm_vpn_gateway.this.name
}

output "bgp_settings" {
  description = "BGP settings of the VPN Gateway"
  value       = azurerm_vpn_gateway.this.bgp_settings
}
