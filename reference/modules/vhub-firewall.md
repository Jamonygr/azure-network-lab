## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allowed_fqdns"></a> [allowed\_fqdns](#input\_allowed\_fqdns) | Public HTTPS allowlist. Network rules do not bypass this list. | `list(string)` | <pre>[<br/>  "www.microsoft.com",<br/>  "learn.microsoft.com"<br/>]</pre> | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_enable_monitoring_egress"></a> [enable\_monitoring\_egress](#input\_enable\_monitoring\_egress) | Permit HTTPS to AzureMonitor service-tag addresses when monitoring agents are configured. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Azure Firewall | `string` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the Firewall Policy | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_source_cidrs"></a> [source\_cidrs](#input\_source\_cidrs) | Exact lab networks allowed by internal rules and public HTTPS allowlist. | `list(string)` | n/a | yes |
| <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id) | ID of the Virtual Hub | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Azure Firewall |
| <a name="output_name"></a> [name](#output\_name) | Name of the Azure Firewall |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | ID of the Firewall Policy |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Private IP address of the firewall |
| <a name="output_public_ip_addresses"></a> [public\_ip\_addresses](#output\_public\_ip\_addresses) | Public IP addresses of the firewall |
