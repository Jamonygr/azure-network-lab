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
| <a name="input_autoscale_max"></a> [autoscale\_max](#input\_autoscale\_max) | Maximum v2 capacity. | `number` | `2` | no |
| <a name="input_autoscale_min"></a> [autoscale\_min](#input\_autoscale\_min) | Minimum v2 capacity; null selects fixed capacity. | `number` | `1` | no |
| <a name="input_backend_ip_addresses"></a> [backend\_ip\_addresses](#input\_backend\_ip\_addresses) | Actual IIS VM private addresses in this VNet. | `list(string)` | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Capacity (instance count) for the Application Gateway | `number` | `1` | no |
| <a name="input_certificate_secret_id"></a> [certificate\_secret\_id](#input\_certificate\_secret\_id) | Versionless existing Key Vault certificate secret URI; caller provides vault network access and RBAC. | `string` | `null` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | HTTPS hostname matching the referenced certificate. | `string` | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Existing certificate-reader user-assigned identity. | `set(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Application Gateway | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU name for the Application Gateway | `string` | `"WAF_v2"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | SKU tier for the Application Gateway | `string` | `"WAF_v2"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet for the Application Gateway | `string` | n/a | yes |
| <a name="input_waf_enabled"></a> [waf\_enabled](#input\_waf\_enabled) | Enable WAF configuration | `bool` | `true` | no |
| <a name="input_waf_mode"></a> [waf\_mode](#input\_waf\_mode) | WAF policy mode. | `string` | `"Prevention"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_pool_id"></a> [backend\_pool\_id](#output\_backend\_pool\_id) | ID of the backend address pool |
| <a name="output_id"></a> [id](#output\_id) | ID of the Application Gateway |
| <a name="output_name"></a> [name](#output\_name) | Name of the Application Gateway |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address of the Application Gateway |
