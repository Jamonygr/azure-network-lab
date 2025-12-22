output "id" {
  description = "ID of the Virtual Hub"
  value       = azurerm_virtual_hub.this.id
}

output "name" {
  description = "Name of the Virtual Hub"
  value       = azurerm_virtual_hub.this.name
}

output "default_route_table_id" {
  description = "ID of the default route table"
  value       = azurerm_virtual_hub.this.default_route_table_id
}
