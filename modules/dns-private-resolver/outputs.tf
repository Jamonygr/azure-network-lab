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

output "forwarding_ruleset_id" {
  description = "DNS forwarding ruleset ID."
  value       = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
}
output "configured_rules" {
  description = "Configured DNS domains and enabled status (no secret data)."
  value       = { for key, rule in azurerm_private_dns_resolver_forwarding_rule.this : key => { domain_name = rule.domain_name, enabled = rule.enabled } }
}
