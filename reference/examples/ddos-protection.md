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
| <a name="input_alert_email"></a> [alert\_email](#input\_alert\_email) | Optional operator-owned email for real DDoS alerts. Empty creates the alert without an action receiver. | `string` | `""` | no |
| <a name="input_enable_paid_features"></a> [enable\_paid\_features](#input\_enable\_paid\_features) | Acknowledge billable resources after reviewing current prices. | `bool` | `false` | no |
| <a name="input_lab_id"></a> [lab\_id](#input\_lab\_id) | Unique disposable lab identifier. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region supporting the selected services. | `string` | `"westeurope"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Existing RSA SSH public key (2048+ bits). Never supply the private key; no public SSH ingress is opened. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Explicit target subscription GUID. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Microsoft Entra tenant GUID. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_attack_alert_id"></a> [attack\_alert\_id](#output\_attack\_alert\_id) | n/a |
| <a name="output_email_notifications_configured"></a> [email\_notifications\_configured](#output\_email\_notifications\_configured) | n/a |
| <a name="output_lab_id"></a> [lab\_id](#output\_lab\_id) | n/a |
| <a name="output_protected_public_ip"></a> [protected\_public\_ip](#output\_protected\_public\_ip) | n/a |
| <a name="output_protected_public_ip_id"></a> [protected\_public\_ip\_id](#output\_protected\_public\_ip\_id) | n/a |
| <a name="output_protection_plan_id"></a> [protection\_plan\_id](#output\_protection\_plan\_id) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | n/a |
