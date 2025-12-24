# Scenario: VPN + BGP

## Goal
Validate site-to-site VPN connectivity between the on-prem VNet and the vHub using BGP.

## Required toggles
- `deploy.vwan = true`
- `deploy.vpn = true`
- `vpn_shared_key` must be set

## Steps
1. Confirm vHub VPN gateway and on-prem VPN gateway exist.
2. Verify VPN site and connection status.
3. Check BGP settings on both sides.

## Commands
```bash
# vHub VPN gateway
az network vhub gateway show -g rg-az700-lab -n vpngw-vhub-az700-lab -o table

# On-prem VPN gateway
az network vnet-gateway show -g rg-az700-lab -n vpngw-onprem-az700-lab -o table

# VPN connection state
az network vpn-connection show -g rg-az700-lab -n conn-onprem-to-vhub-az700-lab -o table
```

## Expected results
- Gateways are Succeeded.
- VPN connection status is Connected.
- BGP ASN 65510 (on-prem) and 65515 (vHub) are visible in outputs.
