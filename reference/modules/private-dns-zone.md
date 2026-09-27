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
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Private DNS Zone | `string` | n/a | yes |
| <a name="input_registration_enabled"></a> [registration\_enabled](#input\_registration\_enabled) | Enable auto-registration for the zone | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_virtual_network_links"></a> [virtual\_network\_links](#input\_virtual\_network\_links) | Map of link names to VNet IDs | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Private DNS Zone |
| <a name="output_name"></a> [name](#output\_name) | Name of the Private DNS Zone |
