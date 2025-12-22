output "id" {
  description = "ID of the Load Balancer"
  value       = azurerm_lb.this.id
}

output "name" {
  description = "Name of the Load Balancer"
  value       = azurerm_lb.this.name
}

output "frontend_ip_address" {
  description = "Frontend IP address of the Load Balancer"
  value       = azurerm_lb.this.frontend_ip_configuration[0].private_ip_address
}

output "backend_pool_id" {
  description = "ID of the backend address pool"
  value       = azurerm_lb_backend_address_pool.this.id
}
