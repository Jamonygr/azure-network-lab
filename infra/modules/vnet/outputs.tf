output "id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to address prefixes"
  value       = { for k, v in azurerm_subnet.subnets : k => v.address_prefixes[0] }
}
