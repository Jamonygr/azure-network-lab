output "flow_log_ids" {
  description = "Lab-owned flow logs under the existing shared watcher; removed by Terraform destruction."
  value       = { for key, flow in azurerm_network_watcher_flow_log.vnet : key => flow.id }
}
output "flow_log_target_ids" {
  description = "Actual monitored VNet resource IDs."
  value       = { for key, flow in azurerm_network_watcher_flow_log.vnet : key => flow.target_resource_id }
}
output "connection_monitor_id" {
  description = "Optional Connection Monitor ID."
  value       = try(azurerm_network_connection_monitor.this[0].id, null)
}
output "diagnostic_setting_ids" {
  description = "Diagnostic settings on the selected service resources."
  value       = { for key, diagnostic in azurerm_monitor_diagnostic_setting.this : key => diagnostic.id }
}
