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
| <a name="input_lab_id"></a> [lab\_id](#input\_lab\_id) | Unique disposable lab identifier. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region supporting the selected services. | `string` | `"westeurope"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Explicit target subscription GUID. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Microsoft Entra tenant GUID. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_deployment_ids"></a> [deployment\_ids](#output\_deployment\_ids) | n/a |
| <a name="output_lab_id"></a> [lab\_id](#output\_lab\_id) | n/a |
| <a name="output_network_manager_id"></a> [network\_manager\_id](#output\_network\_manager\_id) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_vnet_ids"></a> [vnet\_ids](#output\_vnet\_ids) | n/a |
