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
| <a name="input_address_cidrs"></a> [address\_cidrs](#input\_address\_cidrs) | Address CIDRs for the VPN Site (on-prem address space) | `list(string)` | n/a | yes |
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | BGP ASN for the on-prem device | `number` | `65510` | no |
| <a name="input_bgp_enabled"></a> [bgp\_enabled](#input\_bgp\_enabled) | Enable BGP for the VPN connection | `bool` | `true` | no |
| <a name="input_bgp_peering_address"></a> [bgp\_peering\_address](#input\_bgp\_peering\_address) | BGP peering address for the on-prem device | `string` | n/a | yes |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPN Site | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_shared_key"></a> [shared\_key](#input\_shared\_key) | Shared key for the VPN connection | `string` | n/a | yes |
| <a name="input_virtual_wan_id"></a> [virtual\_wan\_id](#input\_virtual\_wan\_id) | ID of the Virtual WAN | `string` | n/a | yes |
| <a name="input_vpn_device_ip"></a> [vpn\_device\_ip](#input\_vpn\_device\_ip) | Public IP of the on-prem VPN device | `string` | n/a | yes |
| <a name="input_vpn_gateway_id"></a> [vpn\_gateway\_id](#input\_vpn\_gateway\_id) | ID of the vHub VPN Gateway | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | ID of the VPN Gateway Connection |
| <a name="output_id"></a> [id](#output\_id) | ID of the VPN Site |
| <a name="output_name"></a> [name](#output\_name) | Name of the VPN Site |
