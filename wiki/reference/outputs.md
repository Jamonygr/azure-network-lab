# Outputs reference

This is a short reference for the outputs in `outputs.tf`.

| Output | Description |
|--------|-------------|
| `resource_group_name` | Resource group name. |
| `resource_group_location` | Resource group location. |
| `vwan_id` | Virtual WAN ID (if enabled). |
| `vhub_id` | Virtual Hub ID (if enabled). |
| `firewall_private_ip` | Firewall private IP (if enabled). |
| `firewall_public_ips` | Firewall public IPs (if enabled). |
| `vnet_spoke1_id` | Spoke1 VNet ID. |
| `vnet_spoke2_id` | Spoke2 VNet ID. |
| `vnet_onprem_id` | OnPrem VNet ID. |
| `onprem_vpn_gateway_public_ip` | OnPrem VPN gateway public IP (if enabled). |
| `vm_spoke1_1_private_ip` | Spoke1 VM 1 private IP (if enabled). |
| `vm_spoke1_2_private_ip` | Spoke1 VM 2 private IP (if enabled). |
| `vm_spoke2_1_private_ip` | Spoke2 VM private IP (if enabled). |
| `vm_onprem_1_private_ip` | OnPrem VM private IP (if enabled). |
| `vm_onprem_nva_private_ip` | OnPrem NVA private IP (if enabled). |
| `load_balancer_frontend_ip` | Internal LB frontend IP (if enabled). |
| `application_gateway_public_ip` | App Gateway public IP (if enabled). |
| `bastion_dns_name` | Bastion DNS name (if enabled). |
| `dns_resolver_inbound_ip` | DNS resolver inbound IP (if enabled). |
| `storage_account_name` | Storage account name (if enabled). |
| `private_endpoint_storage_ip` | Storage private endpoint IP (if enabled). |
| `route_server_id` | Route Server ID (if enabled). |
| `route_server_virtual_router_asn` | Route Server ASN (if enabled). |
| `route_server_virtual_router_ips` | Route Server BGP IPs (if enabled). |
| `vm_spoke1_nva_private_ip` | Spoke1 NVA private IP (if enabled). |
| `connection_info` | Summary map with key connection details. |
