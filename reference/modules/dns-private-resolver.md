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
| <a name="input_forwarding_rules"></a> [forwarding\_rules](#input\_forwarding\_rules) | Conditional DNS forwarding rules for actual reachable DNS servers. | `map(object({ domain_name = string, enabled = optional(bool, true), target_dns_servers = list(object({ ip_address = string, port = optional(number, 53) })) }))` | `{}` | no |
| <a name="input_forwarding_vnet_links"></a> [forwarding\_vnet\_links](#input\_forwarding\_vnet\_links) | Named VNet IDs linked to the forwarding ruleset. | `map(string)` | `{}` | no |
| <a name="input_inbound_subnet_id"></a> [inbound\_subnet\_id](#input\_inbound\_subnet\_id) | ID of the subnet for the inbound endpoint | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the DNS Private Resolver | `string` | n/a | yes |
| <a name="input_outbound_subnet_id"></a> [outbound\_subnet\_id](#input\_outbound\_subnet\_id) | ID of the subnet for the outbound endpoint | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | ID of the Virtual Network for the resolver | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_configured_rules"></a> [configured\_rules](#output\_configured\_rules) | Configured DNS domains and enabled status (no secret data). |
| <a name="output_forwarding_ruleset_id"></a> [forwarding\_ruleset\_id](#output\_forwarding\_ruleset\_id) | DNS forwarding ruleset ID. |
| <a name="output_id"></a> [id](#output\_id) | ID of the DNS Private Resolver |
| <a name="output_inbound_endpoint_ip"></a> [inbound\_endpoint\_ip](#output\_inbound\_endpoint\_ip) | IP address of the inbound endpoint |
| <a name="output_name"></a> [name](#output\_name) | Name of the DNS Private Resolver |
