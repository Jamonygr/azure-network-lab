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
| <a name="input_bgp_connections"></a> [bgp\_connections](#input\_bgp\_connections) | Map of BGP connections to NVAs | <pre>map(object({<br/>    peer_asn = number<br/>    peer_ip  = string<br/>  }))</pre> | `{}` | no |
| <a name="input_branch_to_branch_traffic_enabled"></a> [branch\_to\_branch\_traffic\_enabled](#input\_branch\_to\_branch\_traffic\_enabled) | Enable branch-to-branch traffic (transit between NVAs) | `bool` | `true` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Route Server | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the RouteServerSubnet | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Route Server |
| <a name="output_name"></a> [name](#output\_name) | Name of the Route Server |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address of the Route Server |
| <a name="output_virtual_router_asn"></a> [virtual\_router\_asn](#output\_virtual\_router\_asn) | ASN of the Route Server (always 65515) |
| <a name="output_virtual_router_ips"></a> [virtual\_router\_ips](#output\_virtual\_router\_ips) | BGP peering IPs of the Route Server |
