# Defaults, supported services and lifecycle review

Reviewed 27 September 2026. Current code and the selected region remain the source of deployment requirements.

| Topic | Repository decision and current platform note |
|---|---|
| Toolchain | Terraform 1.16.4; AzureRM 4.57.0; retain lockfiles |
| Default footprint | Network-only main root; optional services explicitly selected |
| Egress | Subnets disable implicit outbound; NAT/Firewall paths are explicit |
| Load balancing | Standard LB; current probe threshold; no new Basic LB |
| App Gateway | WAF_v2; optional certificate-backed frontend; supported TLS policy |
| Front Door | Independent Premium private-origin example; no classic setup |
| Monitoring | VNet flow logs, never new NSG-target flow logs |
| VPN | Review service-specific current SKU guidance rather than equating Basic IP retirement with Basic VPN Gateway retirement |

New VNets created using API versions released after **31 March 2026** default private. Earlier APIs can retain older behavior; existing VNets are not all retroactively disconnected. [Outbound access](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access)

Basic LB retired **30 September 2025**. VMSS inbound NAT-pool creation stops **15 November 2026**, with retirement **30 September 2027**; this is distinct from individual inbound NAT rules. [LB lifecycle](https://learn.microsoft.com/en-us/lifecycle/products/azure-basic-load-balancer), [LB changes](https://learn.microsoft.com/en-us/azure/load-balancer/whats-new)

Application Gateway v1 retired **28 April 2026**. TLS 1.0/1.1 support ended **31 August 2025**. Front Door classic retires **31 March 2027**. [App Gateway retirement](https://learn.microsoft.com/en-us/azure/application-gateway/v1-retirement), [TLS changes](https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-tls-version-retirement), [Front Door FAQ](https://learn.microsoft.com/en-us/azure/frontdoor/classic-retirement-faq)

New NSG flow logs stopped **30 June 2025** and retire **30 September 2027**. [Monitoring guidance](https://learn.microsoft.com/en-us/azure/networking/design-guide/monitor)

VPN Gateway IP migration follows separate service rules; Basic VPN Gateway is not itself declared retired. [Gateway guidance](https://learn.microsoft.com/en-us/azure/vpn-gateway/basic-public-ip-migrate-about)

A supported SKU in source does not prove region availability, quota, zone support or successful provisioning. Those live checks are NOT RUN.
