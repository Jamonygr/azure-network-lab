# Network topology

This lab uses one Virtual Hub, two spokes, and an optional on-premises simulation VNet. Address spaces and subnets are defined in `locals.tf`.

## Address spaces

| Network | CIDR | Purpose |
|---------|------|---------|
| Virtual Hub | 10.10.0.0/23 | vWAN regional hub. |
| Spoke1 | 10.1.0.0/16 | Route Server and workload testing. |
| Spoke2 | 10.2.0.0/16 | Standard vHub connected spoke. |
| OnPrem | 192.168.0.0/16 | Simulated on-premises (optional). |

## Spoke1 subnets

| Subnet | CIDR | Notes |
|--------|------|-------|
| Workload | 10.1.1.0/24 | VMs and LB backend. |
| AppGwSubnet | 10.1.2.0/24 | Application Gateway (optional). |
| AzureBastionSubnet | 10.1.3.0/26 | Bastion (optional). |
| PrivateEndpointSubnet | 10.1.4.0/24 | Storage private endpoint. |
| DnsResolverInbound | 10.1.5.0/28 | DNS resolver inbound endpoint. |
| DnsResolverOutbound | 10.1.5.16/28 | DNS resolver outbound endpoint. |
| LoadBalancerSubnet | 10.1.6.0/24 | Internal LB frontend. |
| RouteServerSubnet | 10.1.7.0/27 | Azure Route Server. |
| NvaSubnet | 10.1.8.0/24 | RRAS NVA VM. |

## Spoke2 subnets

| Subnet | CIDR | Notes |
|--------|------|-------|
| Workload | 10.2.1.0/24 | Workload VM. |

## OnPrem subnets

| Subnet | CIDR | Notes |
|--------|------|-------|
| GatewaySubnet | 192.168.0.0/27 | VPN gateway (optional). |
| Default | 192.168.1.0/24 | Workload VM. |
| NvaSubnet | 192.168.2.0/24 | RRAS NVA VM. |

## Connectivity rules
- Spoke2 connects to vHub when vWAN is enabled.
- Spoke1 connects to vHub only when Route Server is disabled.
- Spoke1 and Spoke2 peer directly when Route Server is enabled.
- VPN connects OnPrem to vHub when `deploy.vpn` is true.
