# Traffic flows

This page describes the most common paths in the lab. All flows depend on the `deploy` toggles and whether Route Server is enabled.

## Flow summary

| Scenario | Path | Notes |
|----------|------|-------|
| Spoke2 -> Internet | Spoke2 -> vHub -> Firewall -> Internet | Requires vWAN and Firewall; routing intent steers traffic. |
| Spoke2 -> OnPrem | Spoke2 -> vHub -> VPN -> OnPrem | Requires `deploy.vpn = true`. |
| Spoke1 -> Spoke2 (Route Server on) | Spoke1 -> VNet peering -> Spoke2 | Spoke1 is not connected to vHub in this mode. |
| Spoke1 -> Spoke2 (Route Server off) | Spoke1 -> vHub -> Spoke2 | Both spokes connect to vHub when allowed. |
| Spoke1 NVA -> Route Server | Within Spoke1 | BGP peering inside the VNet. |
| Storage private endpoint access | VM -> DNS -> Private IP -> Storage | Requires private DNS zones and private endpoint. |

## Notes on conditional behavior

- When `deploy.route_server = true`, Spoke1 is isolated from the vHub.
- When `deploy.vwan = false`, vHub connections are not created.
- When `deploy.vhub_firewall = false`, Internet traffic is not inspected by firewall.

## Suggested tests

- Validate vHub connections: `az network vhub connection list`.
- Validate VPN status: `az network vpn-connection show`.
- Validate private DNS resolution: `Resolve-DnsName <storage>.blob.core.windows.net`.

## Related pages

- Core fabric: `architecture/vwan-and-vhub.md`
- Routing details: `architecture/routing-and-bgp.md`
- Private DNS details: `architecture/dns-and-private-link.md`
