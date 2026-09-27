## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.16.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.14 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_application_gateway"></a> [application\_gateway](#module\_application\_gateway) | ./modules/application-gateway | n/a |
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/bastion | n/a |
| <a name="module_dns_resolver"></a> [dns\_resolver](#module\_dns\_resolver) | ./modules/dns-private-resolver | n/a |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./modules/load-balancer | n/a |
| <a name="module_local_network_gateway_vhub"></a> [local\_network\_gateway\_vhub](#module\_local\_network\_gateway\_vhub) | ./modules/local-network-gateway | n/a |
| <a name="module_log_analytics"></a> [log\_analytics](#module\_log\_analytics) | ./modules/log-analytics | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_nat_gateway"></a> [nat\_gateway](#module\_nat\_gateway) | ./modules/nat-gateway | n/a |
| <a name="module_nat_gateway_other"></a> [nat\_gateway\_other](#module\_nat\_gateway\_other) | ./modules/nat-gateway | n/a |
| <a name="module_nsg"></a> [nsg](#module\_nsg) | ./modules/nsg | n/a |
| <a name="module_private_dns_zone"></a> [private\_dns\_zone](#module\_private\_dns\_zone) | ./modules/private-dns-zone | n/a |
| <a name="module_private_endpoint_storage"></a> [private\_endpoint\_storage](#module\_private\_endpoint\_storage) | ./modules/private-endpoint | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ./modules/resource-group | n/a |
| <a name="module_route_server"></a> [route\_server](#module\_route\_server) | ./modules/route-server | n/a |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ./modules/storage-account | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | ./modules/tags | n/a |
| <a name="module_vhub"></a> [vhub](#module\_vhub) | ./modules/vhub | n/a |
| <a name="module_vhub_connection"></a> [vhub\_connection](#module\_vhub\_connection) | ./modules/vhub-connection | n/a |
| <a name="module_vhub_firewall"></a> [vhub\_firewall](#module\_vhub\_firewall) | ./modules/vhub-firewall | n/a |
| <a name="module_vhub_vpn_gateway"></a> [vhub\_vpn\_gateway](#module\_vhub\_vpn\_gateway) | ./modules/vhub-vpn-gateway | n/a |
| <a name="module_vm_nva"></a> [vm\_nva](#module\_vm\_nva) | ./modules/vm-windows-nva | n/a |
| <a name="module_vm_windows"></a> [vm\_windows](#module\_vm\_windows) | ./modules/vm-windows | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ./modules/vnet | n/a |
| <a name="module_vnet_peering"></a> [vnet\_peering](#module\_vnet\_peering) | ./modules/vnet-peering | n/a |
| <a name="module_vpn_connection_onprem_to_vhub"></a> [vpn\_connection\_onprem\_to\_vhub](#module\_vpn\_connection\_onprem\_to\_vhub) | ./modules/vpn-connection | n/a |
| <a name="module_vpn_gateway_onprem"></a> [vpn\_gateway\_onprem](#module\_vpn\_gateway\_onprem) | ./modules/vpn-gateway | n/a |
| <a name="module_vpn_site_onprem"></a> [vpn\_site\_onprem](#module\_vpn\_site\_onprem) | ./modules/vpn-site | n/a |
| <a name="module_vwan"></a> [vwan](#module\_vwan) | ./modules/vwan | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Optional VM password; supply through TF\_VAR\_admin\_password, never a committed profile. Terraform stores it in state. | `string` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Local administrator on optional Windows VMs. | `string` | `"azureadmin"` | no |
| <a name="input_administration_source_cidrs"></a> [administration\_source\_cidrs](#input\_administration\_source\_cidrs) | Additional exact IPv4 source networks allowed RDP; Bastion subnet is included automatically. | `list(string)` | `[]` | no |
| <a name="input_application_gateway"></a> [application\_gateway](#input\_application\_gateway) | WAF\_v2 settings. HTTPS references an existing Key Vault certificate secret and a reader identity; no PFX/password is stored here. | <pre>object({<br/>    autoscale_min         = optional(number, 1)<br/>    autoscale_max         = optional(number, 2)<br/>    waf_mode              = optional(string, "Prevention")<br/>    certificate_secret_id = optional(string)<br/>    identity_ids          = optional(set(string), [])<br/>    host_name             = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_ctx"></a> [ctx](#input\_ctx) | Lab naming, region and tags; existing project names retain their resource names. | `object({ project = string, location = string, tags = map(string) })` | n/a | yes |
| <a name="input_deploy"></a> [deploy](#input\_deploy) | Opt-in services. Explicit legacy objects retain Log Analytics unless set false; the default is minimal. | <pre>object({<br/>    spoke_peering       = optional(bool, false)<br/>    vwan                = optional(bool, false)<br/>    vhub_firewall       = optional(bool, false)<br/>    vpn                 = optional(bool, false)<br/>    route_server        = optional(bool, false)<br/>    dns_resolver        = optional(bool, false)<br/>    private_dns_zones   = optional(bool, false)<br/>    bastion             = optional(bool, false)<br/>    application_gateway = optional(bool, false)<br/>    load_balancer       = optional(bool, false)<br/>    nat_gateway         = optional(bool, false)<br/>    private_endpoint    = optional(bool, false)<br/>    spoke1_vms          = optional(bool, false)<br/>    spoke2_vms          = optional(bool, false)<br/>    onprem_vms          = optional(bool, false)<br/>    nvas                = optional(bool, false)<br/>    log_analytics       = optional(bool, true)<br/>    monitoring          = optional(bool, false)<br/>  })</pre> | <pre>{<br/>  "log_analytics": false,<br/>  "spoke_peering": true<br/>}</pre> | no |
| <a name="input_dns_forwarding_link_vnets"></a> [dns\_forwarding\_link\_vnets](#input\_dns\_forwarding\_link\_vnets) | VNets linked to the outbound forwarding ruleset. Empty rules create an inert ruleset, not a pretend on-prem DNS server. | `set(string)` | <pre>[<br/>  "spoke1",<br/>  "spoke2"<br/>]</pre> | no |
| <a name="input_dns_forwarding_rules"></a> [dns\_forwarding\_rules](#input\_dns\_forwarding\_rules) | Conditional forwarding to reachable external DNS servers. Domains end in a dot; never point a rule back at this resolver's inbound endpoint. | <pre>map(object({<br/>    domain_name        = string<br/>    target_dns_servers = list(object({ ip_address = string, port = optional(number, 53) }))<br/>    enabled            = optional(bool, true)<br/>  }))</pre> | `{}` | no |
| <a name="input_firewall_allowed_fqdns"></a> [firewall\_allowed\_fqdns](#input\_firewall\_allowed\_fqdns) | HTTPS outbound destinations; all other public destinations are denied. Windows Update uses a separate Microsoft FQDN tag. | `list(string)` | <pre>[<br/>  "www.microsoft.com",<br/>  "learn.microsoft.com"<br/>]</pre> | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Opt-in monitoring settings. Reuse an existing regional Network Watcher; this lab does not own/delete that shared service. | <pre>object({<br/>    network_watcher    = optional(object({ name = string, resource_group_name = string }))<br/>    flow_logs          = optional(bool, true)<br/>    traffic_analytics  = optional(bool, false)<br/>    connection_monitor = optional(bool, false)<br/>    connection_target  = optional(string, "www.microsoft.com")<br/>    retention_days     = optional(number, 7)<br/>  })</pre> | `{}` | no |
| <a name="input_onprem_address_space"></a> [onprem\_address\_space](#input\_onprem\_address\_space) | Canonical nonoverlapping IPv4 ranges; first range /8-/20 supplies stable subnet offsets. | `list(string)` | <pre>[<br/>  "192.168.0.0/16"<br/>]</pre> | no |
| <a name="input_spoke1_address_space"></a> [spoke1\_address\_space](#input\_spoke1\_address\_space) | Canonical nonoverlapping IPv4 ranges; first range /8-/20 supplies stable subnet offsets. | `list(string)` | <pre>[<br/>  "10.1.0.0/16"<br/>]</pre> | no |
| <a name="input_spoke2_address_space"></a> [spoke2\_address\_space](#input\_spoke2\_address\_space) | Canonical nonoverlapping IPv4 ranges; first range /8-/20 supplies stable subnet offsets. | `list(string)` | <pre>[<br/>  "10.2.0.0/16"<br/>]</pre> | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Explicit subscription targeted by this configuration. | `string` | n/a | yes |
| <a name="input_validate_address_plan"></a> [validate\_address\_plan](#input\_validate\_address\_plan) | Always validates all hub/VNet ranges; this is not a bypass switch. | `bool` | `true` | no |
| <a name="input_vhub_address_prefix"></a> [vhub\_address\_prefix](#input\_vhub\_address\_prefix) | Canonical IPv4 hub prefix, /23 or larger, distinct from every VNet prefix. | `string` | `"10.10.0.0/23"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size for optional Windows VMs. | `string` | `"Standard_B2s"` | no |
| <a name="input_vpn_shared_key"></a> [vpn\_shared\_key](#input\_vpn\_shared\_key) | Optional S2S pre-shared key; supply through TF\_VAR\_vpn\_shared\_key. Terraform stores it in state. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_application_gateway_public_ip"></a> [application\_gateway\_public\_ip](#output\_application\_gateway\_public\_ip) | Public IP of the Application Gateway |
| <a name="output_bastion_dns_name"></a> [bastion\_dns\_name](#output\_bastion\_dns\_name) | DNS name of Azure Bastion |
| <a name="output_connected_hub_vnets"></a> [connected\_hub\_vnets](#output\_connected\_hub\_vnets) | Spoke1 is deliberately excluded when Route Server is enabled. |
| <a name="output_connection_info"></a> [connection\_info](#output\_connection\_info) | Summary of connection information |
| <a name="output_dns_forwarding_ruleset_id"></a> [dns\_forwarding\_ruleset\_id](#output\_dns\_forwarding\_ruleset\_id) | Optional DNS conditional forwarding ruleset. |
| <a name="output_dns_resolver_inbound_ip"></a> [dns\_resolver\_inbound\_ip](#output\_dns\_resolver\_inbound\_ip) | Inbound IP of the DNS Private Resolver |
| <a name="output_enabled_services"></a> [enabled\_services](#output\_enabled\_services) | Resolved feature switches for cost and topology review. |
| <a name="output_firewall_private_ip"></a> [firewall\_private\_ip](#output\_firewall\_private\_ip) | Private IP of the Azure Firewall in vHub |
| <a name="output_firewall_public_ips"></a> [firewall\_public\_ips](#output\_firewall\_public\_ips) | Public IPs of the Azure Firewall in vHub |
| <a name="output_load_balancer_frontend_ip"></a> [load\_balancer\_frontend\_ip](#output\_load\_balancer\_frontend\_ip) | Frontend IP of the Internal Load Balancer |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | Optional workspace ARM ID. |
| <a name="output_monitoring_resource_ids"></a> [monitoring\_resource\_ids](#output\_monitoring\_resource\_ids) | Lab-owned monitoring children; the existing Network Watcher is not owned by this lab. |
| <a name="output_onprem_vpn_gateway_public_ip"></a> [onprem\_vpn\_gateway\_public\_ip](#output\_onprem\_vpn\_gateway\_public\_ip) | Public IP of the OnPrem VPN Gateway |
| <a name="output_private_endpoint_storage_ip"></a> [private\_endpoint\_storage\_ip](#output\_private\_endpoint\_storage\_ip) | Private IP of the storage Private Endpoint |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | Location of the resource group |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group |
| <a name="output_route_server_id"></a> [route\_server\_id](#output\_route\_server\_id) | ID of the Azure Route Server |
| <a name="output_route_server_virtual_router_asn"></a> [route\_server\_virtual\_router\_asn](#output\_route\_server\_virtual\_router\_asn) | ASN of the Azure Route Server |
| <a name="output_route_server_virtual_router_ips"></a> [route\_server\_virtual\_router\_ips](#output\_route\_server\_virtual\_router\_ips) | BGP peering IPs of the Azure Route Server |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Name of the storage account |
| <a name="output_subnet_address_plan"></a> [subnet\_address\_plan](#output\_subnet\_address\_plan) | Effective subnet CIDRs, derived from each VNet's first prefix. |
| <a name="output_subnet_default_outbound_access"></a> [subnet\_default\_outbound\_access](#output\_subnet\_default\_outbound\_access) | Every subnet explicitly disables implicit outbound access. |
| <a name="output_vhub_id"></a> [vhub\_id](#output\_vhub\_id) | ID of the Virtual Hub |
| <a name="output_vm_onprem_1_private_ip"></a> [vm\_onprem\_1\_private\_ip](#output\_vm\_onprem\_1\_private\_ip) | Private IP of VM in OnPrem |
| <a name="output_vm_onprem_nva_private_ip"></a> [vm\_onprem\_nva\_private\_ip](#output\_vm\_onprem\_nva\_private\_ip) | Private IP of NVA VM in OnPrem |
| <a name="output_vm_spoke1_1_private_ip"></a> [vm\_spoke1\_1\_private\_ip](#output\_vm\_spoke1\_1\_private\_ip) | Private IP of VM in Spoke1 |
| <a name="output_vm_spoke1_2_private_ip"></a> [vm\_spoke1\_2\_private\_ip](#output\_vm\_spoke1\_2\_private\_ip) | Private IP of second VM in Spoke1 |
| <a name="output_vm_spoke1_nva_private_ip"></a> [vm\_spoke1\_nva\_private\_ip](#output\_vm\_spoke1\_nva\_private\_ip) | Private IP of NVA VM in Spoke1 |
| <a name="output_vm_spoke2_1_private_ip"></a> [vm\_spoke2\_1\_private\_ip](#output\_vm\_spoke2\_1\_private\_ip) | Private IP of VM in Spoke2 |
| <a name="output_vnet_onprem_id"></a> [vnet\_onprem\_id](#output\_vnet\_onprem\_id) | ID of OnPrem VNet |
| <a name="output_vnet_spoke1_id"></a> [vnet\_spoke1\_id](#output\_vnet\_spoke1\_id) | ID of Spoke1 VNet |
| <a name="output_vnet_spoke2_id"></a> [vnet\_spoke2\_id](#output\_vnet\_spoke2\_id) | ID of Spoke2 VNet |
| <a name="output_vwan_id"></a> [vwan\_id](#output\_vwan\_id) | ID of the Virtual WAN |
