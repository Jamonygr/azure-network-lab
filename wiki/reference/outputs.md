# Outputs and evidence

[outputs.tf](../../outputs.tf) defines output names. Outputs report Terraform state, not independently observed reachability. Many optional-service outputs are null when disabled.

| Output group | Names |
|---|---|
| Ownership | `resource_group_name`, `resource_group_location` |
| Root shape | `enabled_services`, `connected_hub_vnets`, `subnet_address_plan`, `subnet_default_outbound_access` |
| Transit | `vwan_id`, `vhub_id`, `firewall_private_ip`, `firewall_public_ips` |
| VNets | `vnet_spoke1_id`, `vnet_spoke2_id`, `vnet_onprem_id` |
| Hybrid | `onprem_vpn_gateway_public_ip` |
| BGP | `route_server_id`, `route_server_virtual_router_asn`, `route_server_virtual_router_ips` |
| DNS/private access | `dns_resolver_inbound_ip`, `dns_forwarding_ruleset_id`, `storage_account_name`, `private_endpoint_storage_ip` |
| Delivery/admin | `load_balancer_frontend_ip`, `application_gateway_public_ip`, `bastion_dns_name` |
| Observation | `log_analytics_workspace_id`, `monitoring_resource_ids` |

VM address outputs and `connection_info` help a future operator select a client; they do not prove guest setup or BGP. Avoid publishing raw output JSON containing live resource identifiers. Collect only the field needed, then redact identifiers in shared evidence.

The independent examples expose their own outputs; read their own `outputs.tf` and README. Do not use root output names in another Terraform directory.
