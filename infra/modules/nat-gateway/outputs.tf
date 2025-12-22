output "id" {
  description = "ID of the NAT Gateway"
  value       = azurerm_nat_gateway.this.id
}

output "name" {
  description = "Name of the NAT Gateway"
  value       = azurerm_nat_gateway.this.name
}

output "public_ip_address" {
  description = "Public IP address of the NAT Gateway"
  value       = azurerm_public_ip.this.ip_address
}
