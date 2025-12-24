# Networking modules

This repo focuses on networking. The modules below are the core building blocks.

## Virtual WAN and hub
- `vwan`: creates the Virtual WAN resource.
- `vhub`: creates a regional Virtual Hub with a /23 prefix.
- `vhub-connection`: connects spoke VNets to the hub.
- `vhub-firewall`: secured hub with Azure Firewall and routing intent.
- `vhub-vpn-gateway`: vHub VPN Gateway for site-to-site connectivity.

## Spoke VNets and routing
- `vnet`: VNet with subnet map support.
- `nsg`: NSG with dynamic rules and subnet associations.
- `vnet-peering`: VNet peering between spokes.
- `route-server`: Azure Route Server with BGP connections.

## VPN and hybrid
- `vpn-gateway`: on-prem VPN gateway inside the simulated VNet.
- `vpn-site`: vWAN VPN site definition.
- `vpn-connection`: S2S VPN connection from on-prem to vHub.
- `local-network-gateway`: local network gateway to the vHub VPN gateway.

## Edge services
- `nat-gateway`: NAT gateway for Spoke1 workload subnet.
- `load-balancer`: internal load balancer for Spoke1 workload.
- `application-gateway`: WAF v2 Application Gateway (optional).
- `bastion`: Azure Bastion for VM access (optional).

## DNS
- `dns-private-resolver`: inbound and outbound endpoints.
- `private-dns-zone`: private DNS zone with VNet links.
