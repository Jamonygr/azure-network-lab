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
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password for the VM | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username for the VM | `string` | n/a | yes |
| <a name="input_advertised_routes"></a> [advertised\_routes](#input\_advertised\_routes) | List of routes to advertise via BGP (CIDR format) | `list(string)` | `[]` | no |
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | BGP ASN for this NVA | `number` | `null` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the NVA Virtual Machine | `string` | n/a | yes |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Static private IP address for the NVA | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_route_server_ips"></a> [route\_server\_ips](#input\_route\_server\_ips) | List of Route Server BGP peer IPs to establish peering with | `list(string)` | `[]` | no |
| <a name="input_size"></a> [size](#input\_size) | Size of the VM | `string` | `"Standard_B2s"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet for the VM | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the NVA Virtual Machine |
| <a name="output_name"></a> [name](#output\_name) | Name of the NVA Virtual Machine |
| <a name="output_network_interface_id"></a> [network\_interface\_id](#output\_network\_interface\_id) | ID of the network interface |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Private IP address of the NVA |
