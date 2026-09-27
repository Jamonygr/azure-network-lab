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
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | BGP ASN for the gateway | `number` | `65510` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | Enable BGP for the gateway | `bool` | `true` | no |
| <a name="input_gateway_subnet_id"></a> [gateway\_subnet\_id](#input\_gateway\_subnet\_id) | ID of the GatewaySubnet | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPN Gateway | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU of the VPN Gateway | `string` | `"VpnGw1"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bgp_peering_address"></a> [bgp\_peering\_address](#output\_bgp\_peering\_address) | BGP peering address |
| <a name="output_bgp_settings"></a> [bgp\_settings](#output\_bgp\_settings) | BGP settings of the VPN Gateway |
| <a name="output_id"></a> [id](#output\_id) | ID of the VPN Gateway |
| <a name="output_name"></a> [name](#output\_name) | Name of the VPN Gateway |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address of the VPN Gateway |
