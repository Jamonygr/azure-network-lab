# External-dependency design exercises

These are paper/configuration reviews. **Azure execution: NOT RUN.** Each has a concrete deliverable; none implies deployment of an unowned provider, appliance or tenant service.

## ExpressRoute resilience and encryption

**Objective/configuration:** select provider model, tier, peerings, gateways, route advertisements, redundancy, encryption and failure detection. No circuit exists in this repository.

**Steps:** use two fictional sites and Azure regions; draw independent peering-location failures; distinguish circuit peering from gateway connection; list accepted/advertised prefixes; compare private versus Microsoft peering; identify Global Reach, FastPath and Direct dependencies; compare IPsec overlay and MACsec applicability; explain BFD's detection boundary.

**Future evidence:** request circuit/peering state, received/advertised BGP routes, gateway routes and provider observations. These are information requests, not fabricated commands against a nonexistent circuit.

**Troubleshooting:** explain a healthy circuit with a filtered prefix and a redundant design with a shared failure domain.

**Cost/cleanup:** inventory provider contracts, cross-connects, circuits, ports, gateways and transfer. Terraform deletion and contract termination have different owners. Submit the diagram, decision table and ownership list. [Microsoft ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/)

## BYOIP and public prefixes

**Objective/configuration:** distinguish customer-owned advertisements, managed public prefixes and individual service addresses. The [reference HCL](../reference/configuration-patterns.md#public-address-and-dns-patterns) covers a managed prefix only.

**Steps:** draw ownership proof, authorization, provisioning, advertisement, assignment and withdrawal. Use `203.0.113.0/24` as documentation-only notation, never as a claim of ownership. Explain which evidence would be necessary before a real prefix could be used.

**Future evidence/troubleshooting:** request ownership and routing records; a resource object alone cannot prove global advertisement. Do not invent deployable BYOIP inputs.

**Cost/cleanup:** inventory allocations and dependent resources; plan withdrawal before deletion. Submit a lifecycle/ownership diagram. [Custom IP prefix guidance](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/custom-ip-address-prefix)

## Gateway Load Balancer appliance

**Objective/configuration:** design insertion, encapsulation, symmetric flow, health and scale. The root Standard internal LB is not a Gateway Load Balancer implementation.

**Steps:** draw a consumer frontend, provider Gateway Load Balancer and two NVAs; label encapsulation interfaces, forward/return flow, supported image/license and failure behavior.

**Future evidence/troubleshooting:** specify captures or counters at both interfaces and a symmetry check. Explain why a healthy VM can still have a broken appliance data path.

**Cost/cleanup:** separate appliance license/compute, frontend and transfer ownership. A future implementation must remove service chains before deleting their provider. Submit the annotated path and dependency list. [Gateway Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/gateway-overview)

## External VPN and client design

**Objective/configuration:** assess external IKE/IPsec compatibility, routing, authentication and client configuration. [Hybrid VPN](vpn-bgp.md) is an Azure-hosted analogue; [P2S](../../examples/point-to-site-vpn/README.md) supplies the configured Entra/OpenVPN path.

**Steps:** build a device/Azure table of protocols, cryptography, NAT, prefixes, ASNs and rekey behavior. Compare Entra, certificate and RADIUS choices by client OS. Identify Always On VPN policy and Azure Network Adapter dependencies. Evaluate Azure Extended Network applicability without implying it is configured.

**Future evidence/troubleshooting:** request authentication result, installed routes, DNS, tunnel/BGP records and an authorized application response. Separate identity, tunnel and route faults. Never include PSKs or exported private credentials.

**Cost/cleanup:** assign ownership of gateways, device licenses, client profiles and revocation. Submit the compatibility table and failure checklist. [VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/)

## Defender investigation

**Objective/configuration:** interpret posture, resource relationships and possible attack paths. No Defender plan is activated here.

**Synthetic case:** a public web entry reaches an application subnet; an overly broad management rule exposes another host; a workload identity has unnecessary service access. These are invented observations, not a real scan.

**Steps:** draw the path; require evidence for each edge; select the smallest network/identity remediation; predict service impact; define rollback. Explain why improving a score is not equivalent to disproving every exploit path.

**Future evidence/troubleshooting:** record observation, confidence, missing evidence, feature/permission prerequisites and remediation. Remove any unsupported edge. Secure Score, attack-path analysis and Cloud Security Explorer must be interpreted within actual feature availability.

**Cost/cleanup:** review plan/licensing/ingestion before future activation. Restore only settings owned by the exercise. Submit the evidence table and remediation rationale. [Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/)
