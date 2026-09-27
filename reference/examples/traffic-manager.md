## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.16.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 4.57.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_paid_features"></a> [enable\_paid\_features](#input\_enable\_paid\_features) | Acknowledge billable resources after reviewing current prices. | `bool` | `false` | no |
| <a name="input_endpoint_weights"></a> [endpoint\_weights](#input\_endpoint\_weights) | Weighted routing values. | `map(number)` | <pre>{<br/>  "primary": 80,<br/>  "secondary": 20<br/>}</pre> | no |
| <a name="input_geographic_mappings"></a> [geographic\_mappings](#input\_geographic\_mappings) | Geo hierarchy codes. WORLD catches unmapped locations. | `map(list(string))` | <pre>{<br/>  "primary": [<br/>    "GEO-EU"<br/>  ],<br/>  "secondary": [<br/>    "WORLD"<br/>  ]<br/>}</pre> | no |
| <a name="input_lab_id"></a> [lab\_id](#input\_lab\_id) | Unique disposable lab identifier. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region supporting the selected services. | `string` | `"westeurope"` | no |
| <a name="input_routing_method"></a> [routing\_method](#input\_routing\_method) | DNS routing algorithm. | `string` | `"Priority"` | no |
| <a name="input_secondary_location"></a> [secondary\_location](#input\_secondary\_location) | Distinct second App Service region. | `string` | `"northeurope"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Explicit target subscription GUID. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Microsoft Entra tenant GUID. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_lab_id"></a> [lab\_id](#output\_lab\_id) | n/a |
| <a name="output_profile_id"></a> [profile\_id](#output\_profile\_id) | n/a |
| <a name="output_regional_urls"></a> [regional\_urls](#output\_regional\_urls) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_routing_method"></a> [routing\_method](#output\_routing\_method) | n/a |
| <a name="output_traffic_manager_fqdn"></a> [traffic\_manager\_fqdn](#output\_traffic\_manager\_fqdn) | n/a |
