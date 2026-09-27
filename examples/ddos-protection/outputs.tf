output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "lab_id" { value = var.lab_id }
output "protection_plan_id" { value = azurerm_network_ddos_protection_plan.lab.id }
output "protected_public_ip_id" { value = azurerm_public_ip.protected.id }
output "protected_public_ip" { value = azurerm_public_ip.protected.ip_address }
output "workspace_name" { value = azurerm_log_analytics_workspace.lab.name }
output "attack_alert_id" { value = azurerm_monitor_metric_alert.attack.id }
output "email_notifications_configured" { value = var.alert_email != "" }
