output "id" {
  description = "ID of the Route Server"
  value       = azurerm_route_server.this.id
}

output "name" {
  description = "Name of the Route Server"
  value       = azurerm_route_server.this.name
}

output "virtual_router_asn" {
  description = "ASN of the Route Server (always 65515)"
  value       = azurerm_route_server.this.virtual_router_asn
}

output "virtual_router_ips" {
  description = "BGP peering IPs of the Route Server"
  value       = azurerm_route_server.this.virtual_router_ips
}

output "public_ip_address" {
  description = "Public IP address of the Route Server"
  value       = azurerm_public_ip.this.ip_address
}
