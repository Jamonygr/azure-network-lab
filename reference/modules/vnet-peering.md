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
| <a name="input_allow_forwarded_traffic"></a> [allow\_forwarded\_traffic](#input\_allow\_forwarded\_traffic) | Allow forwarded traffic | `bool` | `true` | no |
| <a name="input_allow_gateway_transit"></a> [allow\_gateway\_transit](#input\_allow\_gateway\_transit) | Allow gateway transit | `bool` | `false` | no |
| <a name="input_allow_virtual_network_access"></a> [allow\_virtual\_network\_access](#input\_allow\_virtual\_network\_access) | Allow virtual network access | `bool` | `true` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context object (unused but standardized). | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VNet peering | `string` | n/a | yes |
| <a name="input_remote_virtual_network_id"></a> [remote\_virtual\_network\_id](#input\_remote\_virtual\_network\_id) | ID of the remote virtual network | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_use_remote_gateways"></a> [use\_remote\_gateways](#input\_use\_remote\_gateways) | Use remote gateways | `bool` | `false` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the source virtual network | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the VNet peering |
