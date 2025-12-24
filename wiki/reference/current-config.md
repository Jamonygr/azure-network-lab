# Current config (lab profile)

This page mirrors the current values in `terraform.tfvars`. Update this page whenever the lab profile changes.

## ctx
- project: `az700-lab`
- location: `eastus2`
- tags:
  - Owner: `Your Name`
  - CostCenter: `Training`
  - Environment: `lab`
  - Project: `az700`

## deploy
- vwan: true
- vhub_firewall: true
- vpn: false
- route_server: true
- dns_resolver: true
- private_dns_zones: true
- application_gateway: false
- load_balancer: true
- nat_gateway: true
- bastion: false
- private_endpoint: true
- spoke1_vms: true
- spoke2_vms: true
- onprem_vms: false
- nvas: true

## network
- vhub_address_prefix: 10.10.0.0/23
- spoke1_address_space: 10.1.0.0/16
- spoke2_address_space: 10.2.0.0/16
- onprem_address_space: 192.168.0.0/16

## compute
- vm_size: Standard_B1ms
- admin_username: azureadmin

## vpn
- vpn_shared_key: set in `terraform.tfvars` (required if VPN is enabled)
