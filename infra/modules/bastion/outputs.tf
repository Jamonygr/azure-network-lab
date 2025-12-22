output "id" {
  description = "ID of the Bastion Host"
  value       = azurerm_bastion_host.this.id
}

output "name" {
  description = "Name of the Bastion Host"
  value       = azurerm_bastion_host.this.name
}

output "dns_name" {
  description = "DNS name of the Bastion Host"
  value       = azurerm_bastion_host.this.dns_name
}
