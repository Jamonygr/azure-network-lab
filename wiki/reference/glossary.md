# Glossary

Short definitions of the terms used throughout this lab.

## Core networking

- **Virtual WAN (vWAN)**: Azure global transit service that connects hubs, spokes, and branch sites.
- **Virtual Hub (vHub)**: Regional hub in vWAN that provides routing and gateway services.
- **Secured Hub**: A vHub with Azure Firewall and routing intent enabled.
- **VNet (Virtual Network)**: Azure virtual network container for subnets and resources.
- **VNet peering**: Direct connectivity between VNets (non-transitive by default).

## Routing and hybrid

- **Route Server**: Azure service that exchanges routes with NVAs using BGP.
- **BGP (Border Gateway Protocol)**: Dynamic routing protocol used to exchange routes.
- **ASN (Autonomous System Number)**: Identifier for a BGP routing domain.
- **NVA (Network Virtual Appliance)**: A VM that provides routing or security services.
- **RRAS**: Windows Remote Access role used here for BGP on the NVA.
- **VPN Gateway**: Azure gateway that terminates site-to-site VPN connections.
- **VPN Site**: vWAN representation of an on-premises VPN device.
- **Local Network Gateway**: Azure object representing on-premises routing and IP ranges.

## DNS and private access

- **Private DNS Zone**: Azure DNS zone used for private name resolution.
- **DNS Private Resolver**: Azure service for inbound and outbound DNS resolution.
- **Private Endpoint**: Private IP for a PaaS service inside a VNet.

## Security and edge

- **Azure Firewall**: Managed firewall service used for centralized inspection.
- **Routing Intent**: vHub policy that forces traffic through the firewall.
- **NSG (Network Security Group)**: Stateful firewall at subnet or NIC scope.
- **NAT Gateway**: Managed NAT service for outbound traffic.
- **Application Gateway**: Layer 7 load balancer with WAF capability.
- **Load Balancer**: Layer 4 load balancer for TCP/UDP traffic.
