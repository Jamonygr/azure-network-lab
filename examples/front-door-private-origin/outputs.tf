output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "lab_id" { value = var.lab_id }
output "front_door_url" { value = "https://${azurerm_cdn_frontdoor_endpoint.lab.host_name}/" }
output "origin_url" { value = "https://${azurerm_linux_web_app.origin.default_hostname}/" }
output "origin_resource_id" { value = azurerm_linux_web_app.origin.id }
output "private_link_approval_required" { value = true }
