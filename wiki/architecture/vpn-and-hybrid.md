# VPN and hybrid

This lab simulates an on-premises environment and connects it to the vHub using site-to-site VPN with BGP.

## Components

- OnPrem VNet with a VPN gateway.
- vHub VPN gateway in the Virtual Hub.
- vWAN VPN site representing the on-prem device.
- VPN connection between the on-prem gateway and vHub.

## On-prem VPN gateway

Created by `modules/vpn-gateway`:

- Route-based VPN gateway.
- SKU default in the root module: `VpnGw1`.
- BGP enabled with ASN 65510.
- Uses a static public IP.

## vHub VPN gateway

Created by `modules/vhub-vpn-gateway`:

- Scale unit defaults to 1.
- BGP ASN 65515.
- Attached directly to the vHub.

## VPN site and connection

Created by `modules/vpn-site`:

- vWAN VPN site uses the on-prem public IP and address space.
- BGP settings use ASN 65510 and the on-prem BGP peering address.
- vWAN VPN gateway connection uses the shared key and BGP.

A separate `modules/vpn-connection` creates the on-prem gateway connection to the local network gateway representation of the vHub.

## Dependencies

- Requires `deploy.vwan = true` and `deploy.vpn = true`.
- Requires `vpn_shared_key` in `terraform.tfvars`.

## Validation commands

```bash
az network vhub gateway show -g rg-<prefix> -n vpngw-vhub-<prefix> -o table
az network vnet-gateway show -g rg-<prefix> -n vpngw-onprem-<prefix> -o table
az network vpn-connection show -g rg-<prefix> -n conn-onprem-to-vhub-<prefix> -o table
```

## Related pages

- Routing overview: `architecture/routing-and-bgp.md`
- VPN scenario: `scenarios/vpn-bgp.md`
