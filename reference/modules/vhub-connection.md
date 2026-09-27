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
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context object (unused but standardized). | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_internet_security_enabled"></a> [internet\_security\_enabled](#input\_internet\_security\_enabled) | Enable internet security (route internet traffic through secured hub) | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Virtual Hub Connection | `string` | n/a | yes |
| <a name="input_remote_virtual_network_id"></a> [remote\_virtual\_network\_id](#input\_remote\_virtual\_network\_id) | ID of the remote Virtual Network to connect | `string` | n/a | yes |
| <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id) | ID of the Virtual Hub | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Virtual Hub Connection |
| <a name="output_name"></a> [name](#output\_name) | Name of the Virtual Hub Connection |
