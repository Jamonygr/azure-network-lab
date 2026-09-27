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
| <a name="input_name"></a> [name](#input\_name) | Name of the VPN Gateway | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_scale_unit"></a> [scale\_unit](#input\_scale\_unit) | Scale unit for the VPN Gateway | `number` | `1` | no |
| <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id) | ID of the Virtual Hub | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bgp_settings"></a> [bgp\_settings](#output\_bgp\_settings) | BGP settings of the VPN Gateway |
| <a name="output_id"></a> [id](#output\_id) | ID of the VPN Gateway |
| <a name="output_name"></a> [name](#output\_name) | Name of the VPN Gateway |
