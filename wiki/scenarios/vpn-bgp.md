# Scenario: VPN and BGP

<p align="center">
  <img src="../images/scenarios-vpn-bgp.svg" alt="Scenario: VPN and BGP banner" width="1000" />
</p>


## Goal

Validate the site-to-site VPN and BGP adjacency between the on-prem simulation and the vHub VPN gateway.

## Required toggles

- `deploy.vwan = true`
- `deploy.vpn = true`

## Optional toggles

- `deploy.onprem_vms` if you want to test VM-to-VM connectivity.

## Steps

1. Apply the lab and capture outputs.
2. Confirm vHub VPN gateway and on-prem VPN gateway exist.
3. Verify the VPN connection status is Connected.
4. Validate BGP peer status on the on-prem gateway.

## Commands

```bash
az network vhub gateway show -g rg-<prefix> -n vpngw-vhub-<prefix> -o table
az network vnet-gateway show -g rg-<prefix> -n vpngw-onprem-<prefix> -o table
az network vpn-connection show -g rg-<prefix> -n conn-onprem-to-vhub-<prefix> -o table

# BGP peer status (on-prem gateway)
az network vnet-gateway list-bgp-peer-status -g rg-<prefix> -n vpngw-onprem-<prefix> -o table
```

## Expected results

- Gateways are in Succeeded state.
- VPN connection shows Connected.
- BGP peer status is Connected for ASN 65515.

## Notes

- Replace `<prefix>` with `ctx.project`.
- Ensure `vpn_shared_key` is set in `terraform.tfvars`.
- If BGP shows down, check IPsec status and shared key.

## Related pages

- [VPN and hybrid](../architecture/vpn-and-hybrid.md)
- [Routing and BGP](../architecture/routing-and-bgp.md)
- [Route validation](../testing/route-validation.md)
- [ASNs and IPs](../reference/asn-and-ips.md)
