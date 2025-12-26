# Outputs reference

Outputs are defined in `outputs.tf`. Many outputs are conditional and will be `null` when the related service is disabled.

## Core outputs

| Output | Description |
|--------|-------------|
| `resource_group_name` | Resource group name. |
| `resource_group_location` | Resource group location. |
| `vwan_id` | Virtual WAN ID (if enabled). |
| `vhub_id` | Virtual Hub ID (if enabled). |

## Security and hub

| Output | Description |
|--------|-------------|
| `firewall_private_ip` | Firewall private IP (if enabled). |
| `firewall_public_ips` | Firewall public IPs (if enabled). |

## VNets and VMs

| Output | Description |
|--------|-------------|
| `vnet_spoke1_id` | Spoke1 VNet ID. |
| `vnet_spoke2_id` | Spoke2 VNet ID. |
| `vnet_onprem_id` | OnPrem VNet ID. |
| `vm_spoke1_1_private_ip` | Spoke1 VM 1 private IP (if enabled). |
| `vm_spoke1_2_private_ip` | Spoke1 VM 2 private IP (if enabled). |
| `vm_spoke2_1_private_ip` | Spoke2 VM private IP (if enabled). |
| `vm_onprem_1_private_ip` | OnPrem VM private IP (if enabled). |
| `vm_spoke1_nva_private_ip` | Spoke1 NVA private IP (if enabled). |
| `vm_onprem_nva_private_ip` | OnPrem NVA private IP (if enabled). |

## VPN and routing

| Output | Description |
|--------|-------------|
| `onprem_vpn_gateway_public_ip` | OnPrem VPN gateway public IP (if enabled). |
| `route_server_id` | Route Server ID (if enabled). |
| `route_server_virtual_router_asn` | Route Server ASN (if enabled). |
| `route_server_virtual_router_ips` | Route Server BGP IPs (if enabled). |

## DNS and private endpoints

| Output | Description |
|--------|-------------|
| `dns_resolver_inbound_ip` | DNS resolver inbound IP (if enabled). |
| `storage_account_name` | Storage account name (if enabled). |
| `private_endpoint_storage_ip` | Storage private endpoint IP (if enabled). |

## Edge services

| Output | Description |
|--------|-------------|
| `load_balancer_frontend_ip` | Internal LB frontend IP (if enabled). |
| `application_gateway_public_ip` | App Gateway public IP (if enabled). |
| `bastion_dns_name` | Bastion DNS name (if enabled). |

## connection_info

`connection_info` is a summary map of the most useful addresses and access hints.

Example shape:

```hcl
connection_info = {
  bastion_connect = "Connect via Azure Portal -> Bastion -> bas-<prefix>"
  vm_admin_user   = "azureadmin"
  spoke1_vms      = ["10.1.1.4", "10.1.1.5"]
  spoke1_nva      = "10.1.8.10"
  spoke2_vms      = ["10.2.1.4"]
  onprem_vms      = ["192.168.1.4", "192.168.2.10"]
  route_server    = { asn = 65515, peer_ips = ["10.1.7.4", "10.1.7.5"] }
}
```

## Usage

```bash
terraform output
terraform output -json
```
