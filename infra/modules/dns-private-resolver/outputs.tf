output "id" {
  description = "ID of the DNS Private Resolver"
  value       = azurerm_private_dns_resolver.this.id
}

output "name" {
  description = "Name of the DNS Private Resolver"
  value       = azurerm_private_dns_resolver.this.name
}

output "inbound_endpoint_ip" {
  description = "IP address of the inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.this.ip_configurations[0].private_ip_address
}
