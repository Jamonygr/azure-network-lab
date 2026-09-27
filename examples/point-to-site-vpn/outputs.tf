output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "lab_id" { value = var.lab_id }
output "gateway_name" { value = azurerm_virtual_network_gateway.lab.name }
output "gateway_id" { value = azurerm_virtual_network_gateway.lab.id }
output "gateway_public_ip" { value = azurerm_public_ip.gateway.ip_address }
output "target_url" { value = "http://10.88.1.10/" }
output "target_vm_name" { value = azurerm_linux_virtual_machine.target.name }
