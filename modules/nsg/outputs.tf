output "id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.this.id
}

output "name" {
  description = "Name of the Network Security Group"
  value       = azurerm_network_security_group.this.name
}

output "rule_sources" {
  description = "Actual NSG source/access settings for configuration verification."
  value       = { for key, rule in azurerm_network_security_rule.rules : key => { access = rule.access, source = rule.source_address_prefix, sources = rule.source_address_prefixes } }
}
