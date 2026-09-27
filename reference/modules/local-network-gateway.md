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
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address space of the remote network (Azure vHub + spokes) | `list(string)` | n/a | yes |
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | BGP ASN of the remote gateway | `number` | `65515` | no |
| <a name="input_bgp_enabled"></a> [bgp\_enabled](#input\_bgp\_enabled) | Enable BGP for the Local Network Gateway | `bool` | `true` | no |
| <a name="input_bgp_peering_address"></a> [bgp\_peering\_address](#input\_bgp\_peering\_address) | BGP peering address of the remote gateway | `string` | `""` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_gateway_address"></a> [gateway\_address](#input\_gateway\_address) | IP address of the remote gateway (vHub VPN GW public IP) | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Local Network Gateway | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Local Network Gateway |
| <a name="output_name"></a> [name](#output\_name) | Name of the Local Network Gateway |
