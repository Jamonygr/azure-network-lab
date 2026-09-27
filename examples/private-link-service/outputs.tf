output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "lab_id" { value = var.lab_id }
output "consumer_vm_name" { value = azurerm_linux_virtual_machine.consumer.name }
output "backend_vm_name" { value = azurerm_linux_virtual_machine.backend.name }
output "private_link_service_id" { value = azurerm_private_link_service.lab.id }
output "private_endpoint_ip" { value = azurerm_private_endpoint.consumer.private_service_connection[0].private_ip_address }
output "service_url" { value = "http://web.networklab.internal/" }
