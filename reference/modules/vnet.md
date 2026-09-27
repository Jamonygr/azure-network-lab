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
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address space for the VNet | `list(string)` | n/a | yes |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Virtual Network | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create | <pre>map(object({<br/>    address_prefix                    = string<br/>    service_endpoints                 = optional(list(string), [])<br/>    private_endpoint_network_policies = optional(string, "Enabled")<br/>    delegation = optional(object({<br/>      name         = string<br/>      service_name = string<br/>      actions      = list(string)<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | Address space of the Virtual Network |
| <a name="output_default_outbound_access"></a> [default\_outbound\_access](#output\_default\_outbound\_access) | Explicit outbound setting on every subnet. |
| <a name="output_id"></a> [id](#output\_id) | ID of the Virtual Network |
| <a name="output_name"></a> [name](#output\_name) | Name of the Virtual Network |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | Map of subnet names to address prefixes |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet names to IDs |
| <a name="output_subnet_prefixes"></a> [subnet\_prefixes](#output\_subnet\_prefixes) | Effective subnet prefixes for address-plan checks. |
