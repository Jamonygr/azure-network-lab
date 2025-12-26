# ASNs and IPs

This page summarizes the default ASNs and key IP addresses used in the lab. Dynamic values (like vHub gateway IPs) are derived during apply and may not be exposed as outputs.

## BGP ASNs

| Component | ASN | Source |
|-----------|-----|--------|
| vHub VPN Gateway | 65515 | `modules/vhub-vpn-gateway` |
| Azure Route Server | 65515 | Azure default (Route Server) |
| Spoke1 NVA (RRAS) | 65501 | `locals.vm_nva` |
| OnPrem VPN Gateway | 65510 | `main.tf` |

## Default NVA IPs

| NVA | IP | Subnet |
|-----|----|--------|
| Spoke1 NVA | 10.1.8.10 | Spoke1 `NvaSubnet` |
| OnPrem NVA | 192.168.2.10 | OnPrem `NvaSubnet` |

## Route Server IPs

Route Server peer IPs are created by Azure and returned in outputs:

- `route_server_virtual_router_ips`

Use these for BGP peering validation and NVA configuration checks.

## vHub gateway IPs

The vHub VPN gateway exposes tunnel and default IPs used by the local network gateway:

- `local.vhub_gateway_tunnel_ip`
- `local.vhub_gateway_default_ip`

These are derived in `locals.tf` and are not exposed as outputs by default. Use `terraform console` or the state file if you need to inspect them.

## Address spaces (default)

| Network | CIDR |
|---------|------|
| vHub | 10.10.0.0/23 |
| Spoke1 | 10.1.0.0/16 |
| Spoke2 | 10.2.0.0/16 |
| OnPrem | 192.168.0.0/16 |

## Related pages

- Network topology: `architecture/network-topology.md`
- Routing: `architecture/routing-and-bgp.md`
