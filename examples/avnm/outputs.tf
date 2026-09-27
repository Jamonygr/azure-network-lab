output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "lab_id" { value = var.lab_id }
output "network_manager_id" { value = azurerm_network_manager.lab.id }
output "vnet_ids" { value = { for name, vnet in azurerm_virtual_network.lab : name => vnet.id } }
output "deployment_ids" { value = { connectivity = azurerm_network_manager_deployment.connectivity.id, security = azurerm_network_manager_deployment.security.id, routing = azurerm_network_manager_deployment.routing.id } }
