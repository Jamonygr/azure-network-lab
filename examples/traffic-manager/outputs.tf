output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "lab_id" { value = var.lab_id }
output "traffic_manager_fqdn" { value = azurerm_traffic_manager_profile.lab.fqdn }
output "regional_urls" { value = { for name, app in azurerm_linux_web_app.region : name => "https://${app.default_hostname}/" } }
output "profile_id" { value = azurerm_traffic_manager_profile.lab.id }
output "routing_method" { value = var.routing_method }
