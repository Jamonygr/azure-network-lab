# Domain 2 — Connectivity services

The [hybrid profile](../scenarios/vpn-bgp.md) is an Azure-to-Azure branch simulation. The [vWAN profile](../scenarios/secured-hub-firewall.md) teaches hub attachment and inspection. The [P2S root](../../examples/point-to-site-vpn/README.md) is independent. ExpressRoute and external hardware are [design exercises](../scenarios/design-exercises.md).

## Compare connectivity models

| Choice | Main decision | Failure evidence to request |
|---|---|---|
| S2S VPN | Public internet transport, IKE/IPsec compatibility, routing and redundancy | Tunnel status, negotiation logs, advertised prefixes, packet counters |
| P2S VPN | Client OS, tunnel protocol, user authentication and address pool | Client logs, token/authentication result, installed routes and DNS |
| ExpressRoute | Provider/model, peering, resiliency and encryption boundary | Circuit/peering state, BGP advertisements, gateway routes, provider evidence |
| Virtual WAN | Hub design, routing domains, scale units and inspection | Connection association/propagation, effective routes, selected security next hop |

A resource provisioning result proves none of the four end-to-end paths. An operational tunnel can still carry no useful traffic when routes, NSGs, return paths, or DNS are wrong.

## VPN exercise reasoning

Before reviewing the VPN profile, write a table of local/remote prefixes, gateway public addresses, BGP ASNs, peer addresses, IKE parameters, and expected return routes. The shared key is a secret and must never appear in evidence. The branch VNet is hosted in Azure and uses an Azure gateway; it is not an external-device compatibility test.

P2S requires an actual client, user authorization and client profile import. The example's Entra configuration does not create tenant consent or prove user sign-in. Compare RADIUS/certificate alternatives in the design worksheet rather than pretending they are also configured.

VPN Gateway SKU guidance evolves independently from Basic public IP retirement. Do not describe Basic VPN Gateway as retired. Follow [current SKU guidance](https://learn.microsoft.com/en-us/azure/vpn-gateway/gateway-sku-consolidation) and [service-specific IP migration guidance](https://learn.microsoft.com/en-us/azure/vpn-gateway/basic-public-ip-migrate-about) when reviewing old deployments.

## Completion artifact

Draw normal and failed paths across two failure domains. Specify which prefixes remain reachable after loss of one tunnel, gateway instance, peering location, or region. For ExpressRoute, explain how private peering differs from Microsoft peering and why private transport does not automatically imply payload encryption. Document the gateway and provider dependencies that remain outside Terraform.
