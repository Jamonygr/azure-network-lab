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
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Existing RSA SSH public key (2048+ bits). Never supply the private key; no public SSH ingress is opened. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Explicit target subscription GUID. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Microsoft Entra tenant GUID. | `string` | n/a | yes |
| <a name="input_vpn_aad_audience"></a> [vpn\_aad\_audience](#input\_vpn\_aad\_audience) | Audience GUID for the Azure VPN application approved in your tenant; select it from current Microsoft instructions. | `string` | n/a | yes |
| <a name="input_vpn_aad_issuer_url"></a> [vpn\_aad\_issuer\_url](#input\_vpn\_aad\_issuer\_url) | Explicit issuer URL from your tenant configuration, including trailing slash. | `string` | n/a | yes |
| <a name="input_vpn_aad_tenant_url"></a> [vpn\_aad\_tenant\_url](#input\_vpn\_aad\_tenant\_url) | Explicit global-Azure Entra tenant URL, without trailing slash. | `string` | n/a | yes |
| <a name="input_vpn_client_address_pool"></a> [vpn\_client\_address\_pool](#input\_vpn\_client\_address\_pool) | Canonical private IPv4 /16 through /29 client pool, nonoverlapping with lab 10.88.0.0/16. Check other local/on-prem networks manually. | `string` | `"172.28.10.0/24"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | n/a |
| <a name="output_gateway_name"></a> [gateway\_name](#output\_gateway\_name) | n/a |
| <a name="output_gateway_public_ip"></a> [gateway\_public\_ip](#output\_gateway\_public\_ip) | n/a |
| <a name="output_lab_id"></a> [lab\_id](#output\_lab\_id) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_target_url"></a> [target\_url](#output\_target\_url) | n/a |
| <a name="output_target_vm_name"></a> [target\_vm\_name](#output\_target\_vm\_name) | n/a |
