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
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | Enable BGP for the connection | `bool` | `true` | no |
| <a name="input_local_network_gateway_id"></a> [local\_network\_gateway\_id](#input\_local\_network\_gateway\_id) | ID of the Local Network Gateway | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPN Connection | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_shared_key"></a> [shared\_key](#input\_shared\_key) | Shared key for the VPN connection | `string` | n/a | yes |
| <a name="input_virtual_network_gateway_id"></a> [virtual\_network\_gateway\_id](#input\_virtual\_network\_gateway\_id) | ID of the Virtual Network Gateway | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the VPN Connection |
| <a name="output_name"></a> [name](#output\_name) | Name of the VPN Connection |
