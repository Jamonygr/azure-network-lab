# Security model

The lab uses layered security with a focus on visibility and learning, not strict lockdown. The defaults are intentionally permissive to make lab testing easy, but the hardening checklist explains how to tighten them.

## Layers of protection

- Hub security: optional Azure Firewall with routing intent.
- Subnet security: NSGs on workload and NVA subnets.
- PaaS access: storage account is private by default.
- Identity: local VM admin credentials plus VPN shared keys.

## Network Security Groups (NSGs)

Baseline rules are applied to workload and NVA subnets:

| Rule | Port/Proto | Source | Purpose |
|------|------------|--------|---------|
| AllowRDP | TCP 3389 | 10.0.0.0/8 | Lab VM access. |
| AllowICMP | ICMP | * | Ping tests. |
| AllowHTTP | TCP 80 | * | Web tests for ILB/App Gateway. |
| AllowHTTPS | TCP 443 | * | HTTPS tests. |

On-premises NSG adds:

- AllowRDPFromInternet: TCP 3389 from 192.168.0.0/16.

## Secured hub (Azure Firewall)

When enabled, the lab deploys:

- Azure Firewall (hub SKU).
- Firewall Policy with default allow rules for lab traffic.
- Routing Intent for Internet and private traffic.

Current firewall policy behavior (lab default):

- Allow all outbound TCP/UDP/ICMP from 10.0.0.0/8 and 192.168.0.0/16.
- Allow HTTP/HTTPS application traffic from the same ranges.
- Threat intelligence mode is set to Alert.
- DNS proxy is enabled.

## Private access

- Storage account public access is disabled.
- Private Endpoint is created in Spoke1 when enabled.
- Private DNS zones provide name resolution for private endpoints.

## NVA security

- NVA NICs have IP forwarding enabled.
- RRAS and BGP are configured by a startup script and scheduled task.

## Operational guidance

- Use Bastion when enabled for administrative access.
- Rotate admin passwords and VPN shared keys.
- For real-world hardening steps, see `reference/hardening.md`.
