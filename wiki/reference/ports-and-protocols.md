# Ports and protocols

This page lists the common ports and protocols used in lab tests. Some traffic is handled by Azure-managed services and does not traverse VM NSGs.

## Lab traffic ports

| Protocol | Port | Used for | Where it applies |
|----------|------|----------|-----------------|
| TCP | 3389 | RDP to Windows VMs | NSG rules on workload subnets. |
| TCP | 80 | HTTP testing for ILB/App Gateway | NSG rules on workload subnets. |
| TCP | 443 | HTTPS testing | NSG rules on workload subnets. |
| ICMP | n/a | Ping tests | NSG rules on workload subnets. |
| TCP | 179 | BGP sessions | RRAS NVA to Route Server, VPN BGP. |
| UDP | 53 | DNS queries | VM to DNS resolver or Azure DNS. |
| UDP | 500/4500 | IKEv2 VPN | VPN gateways (Azure-managed). |

## Notes

- BGP sessions are configured by the NVA and VPN gateways; NSG rules do not govern Route Server or VPN gateways.
- If Bastion is enabled, management access flows through HTTPS (443) via the Azure Portal.
- Adjust NSG rules carefully if you are validating firewall or routing behavior.
