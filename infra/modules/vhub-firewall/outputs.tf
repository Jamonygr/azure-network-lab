output "id" {
  description = "ID of the Azure Firewall"
  value       = azurerm_firewall.this.id
}

output "name" {
  description = "Name of the Azure Firewall"
  value       = azurerm_firewall.this.name
}

output "private_ip_address" {
  description = "Private IP address of the firewall"
  value       = azurerm_firewall.this.virtual_hub[0].private_ip_address
}

output "public_ip_addresses" {
  description = "Public IP addresses of the firewall"
  value       = azurerm_firewall.this.virtual_hub[0].public_ip_addresses
}

output "policy_id" {
  description = "ID of the Firewall Policy"
  value       = azurerm_firewall_policy.this.id
}
