output "id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.id
}

output "name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.name
}

output "workspace_id" {
  description = "Workspace ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "primary_shared_key" {
  description = "Primary shared key of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}
