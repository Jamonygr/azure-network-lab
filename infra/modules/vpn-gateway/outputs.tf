output "id" {
  description = "ID of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.this.id
}

output "name" {
  description = "Name of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.this.name
}

output "public_ip_address" {
  description = "Public IP address of the VPN Gateway"
  value       = azurerm_public_ip.this.ip_address
}

output "bgp_settings" {
  description = "BGP settings of the VPN Gateway"
  value       = var.enable_bgp ? azurerm_virtual_network_gateway.this.bgp_settings : null
}

output "bgp_peering_address" {
  description = "BGP peering address"
  value       = var.enable_bgp ? azurerm_virtual_network_gateway.this.bgp_settings[0].peering_addresses[0].default_addresses[0] : null
}
