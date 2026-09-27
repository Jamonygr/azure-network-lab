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
| <a name="input_name"></a> [name](#input\_name) | Name of the Network Security Group | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_security_rules"></a> [security\_rules](#input\_security\_rules) | Map of security rules | <pre>map(object({<br/>    priority                   = number<br/>    direction                  = string<br/>    access                     = string<br/>    protocol                   = string<br/>    source_port_range          = string<br/>    destination_port_range     = string<br/>    source_address_prefix      = optional(string)<br/>    source_address_prefixes    = optional(list(string))<br/>    destination_address_prefix = string<br/>  }))</pre> | `{}` | no |
| <a name="input_subnet_associations"></a> [subnet\_associations](#input\_subnet\_associations) | Map of subnet names to subnet IDs for NSG association | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Network Security Group |
| <a name="output_name"></a> [name](#output\_name) | Name of the Network Security Group |
| <a name="output_rule_sources"></a> [rule\_sources](#output\_rule\_sources) | Actual NSG source/access settings for configuration verification. |
