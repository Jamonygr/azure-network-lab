## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_network_watcher.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_watcher) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_connection_monitor"></a> [connection\_monitor](#input\_connection\_monitor) | Enable a TCP/443 probe and Windows Network Watcher agent. | `bool` | `false` | no |
| <a name="input_connection_target"></a> [connection\_target](#input\_connection\_target) | Approved destination for the TCP/443 probe. | `string` | `"www.microsoft.com"` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Location and tags. | `object({ project = string, location = string, tags = map(string) })` | n/a | yes |
| <a name="input_diagnostic_target_ids"></a> [diagnostic\_target\_ids](#input\_diagnostic\_target\_ids) | Enabled Firewall, Application Gateway and VPN resources. | `map(string)` | `{}` | no |
| <a name="input_flow_logs"></a> [flow\_logs](#input\_flow\_logs) | Enable VNet flow logs and a dedicated storage account. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Lab prefix for monitoring resources. | `string` | n/a | yes |
| <a name="input_network_watcher"></a> [network\_watcher](#input\_network\_watcher) | Existing Network Watcher in the lab region, needed for flow logs or Connection Monitor. | `object({ name = string, resource_group_name = string })` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Lab resource group; shared Network Watcher is read only. | `string` | n/a | yes |
| <a name="input_retention_days"></a> [retention\_days](#input\_retention\_days) | Flow-log retention, 1-30 days for this lab. | `number` | `7` | no |
| <a name="input_source_vm_id"></a> [source\_vm\_id](#input\_source\_vm\_id) | Existing Windows VM to run the connectivity probe. | `string` | `null` | no |
| <a name="input_traffic_analytics"></a> [traffic\_analytics](#input\_traffic\_analytics) | Opt-in paid flow analysis. | `bool` | `false` | no |
| <a name="input_vnet_ids"></a> [vnet\_ids](#input\_vnet\_ids) | VNets receiving VNet flow logs, never legacy NSG flow logs. | `map(string)` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | Log Analytics workspace GUID for Traffic Analytics. | `string` | n/a | yes |
| <a name="input_workspace_resource_id"></a> [workspace\_resource\_id](#input\_workspace\_resource\_id) | Destination Log Analytics ARM resource ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_connection_monitor_id"></a> [connection\_monitor\_id](#output\_connection\_monitor\_id) | Optional Connection Monitor ID. |
| <a name="output_diagnostic_setting_ids"></a> [diagnostic\_setting\_ids](#output\_diagnostic\_setting\_ids) | Diagnostic settings on the selected service resources. |
| <a name="output_flow_log_ids"></a> [flow\_log\_ids](#output\_flow\_log\_ids) | Lab-owned flow logs under the existing shared watcher; removed by Terraform destruction. |
| <a name="output_flow_log_target_ids"></a> [flow\_log\_target\_ids](#output\_flow\_log\_target\_ids) | Actual monitored VNet resource IDs. |
