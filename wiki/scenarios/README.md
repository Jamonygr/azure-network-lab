# Exercises and configuration paths

Every exercise states configuration, review steps, future commands, evidence, troubleshooting, cost and cleanup. **Azure activity: NOT RUN.** Source review and synthetic reasoning need no cloud credentials.

| Exercise | Root profile |
|---|---|
| [Minimal address and security footprint](minimal-cost.md) | `minimal` |
| [Virtual WAN connection ownership](vwan-basics.md) | `vwan-secured` |
| [Secured hub: path before policy](secured-hub-firewall.md) | `vwan-secured` |
| [Hybrid VPN: Azure-hosted branch](vpn-bgp.md) | `hybrid-vpn` |
| [Route Server: routes are not packets](route-server-bgp.md) | `route-server` |
| [Private Blob access and DNS](private-endpoints-dns.md) | `private-dns` |
| [Regional application delivery](edge-services.md) | `application-delivery` |
| [Legacy combined topology review](full-lab.md) | `legacy-combined` |
| [Independent examples](independent-examples.md) | Seven separate roots |
| [Design exercises](design-exercises.md) | External/provider-dependent worksheets |

Read [state isolation](../reference/state-and-secrets.md) before selecting another profile. Two profiles do not merge their deploy objects: Terraform uses the last value. The [book](../book.md) gives the five-domain course sequence.
