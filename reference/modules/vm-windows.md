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
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password for the VM | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username for the VM | `string` | n/a | yes |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Context for location and tags. | <pre>object({<br/>    project  = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_install_web_server"></a> [install\_web\_server](#input\_install\_web\_server) | Install IIS and a health endpoint using the checked-in, secret-free bootstrap script. | `bool` | `false` | no |
| <a name="input_join_lb_backend_pool"></a> [join\_lb\_backend\_pool](#input\_join\_lb\_backend\_pool) | Whether to join the VM to a load balancer backend pool | `bool` | `false` | no |
| <a name="input_lb_backend_pool_id"></a> [lb\_backend\_pool\_id](#input\_lb\_backend\_pool\_id) | ID of the Load Balancer backend pool to join (optional) | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Virtual Machine | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Size of the VM | `string` | `"Standard_B2s"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet for the VM | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Virtual Machine |
| <a name="output_name"></a> [name](#output\_name) | Name of the Virtual Machine |
| <a name="output_network_interface_id"></a> [network\_interface\_id](#output\_network\_interface\_id) | ID of the network interface |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Private IP address of the VM |
