output "id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "name" {
  description = "Name of the Application Gateway"
  value       = azurerm_application_gateway.this.name
}

output "public_ip_address" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.this.ip_address
}

output "backend_pool_id" {
  description = "ID of the backend address pool"
  value       = one(azurerm_application_gateway.this.backend_address_pool).id
}
