output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "lab_id" { value = var.lab_id }
output "allowed_storage_resource_group" { value = azurerm_resource_group.allowed_storage.name }
output "storage_accounts" { value = { for name, account in azurerm_storage_account.target : name => account.name } }
output "client_vm_name" { value = azurerm_linux_virtual_machine.client.name }
output "policy_id" { value = azurerm_subnet_service_endpoint_storage_policy.lab.id }
output "client_identity_principal_id" { value = azurerm_linux_virtual_machine.client.identity[0].principal_id }
