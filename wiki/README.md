# Azure Network Lab documentation

Azure Network Lab is a vWAN-centric Terraform lab focused on AZ-700 networking skills. The docs are structured like a small wiki: short pages, cross-links, and deep testing notes so you can explore topics the way you would on Wikipedia.

## Project quick facts

| Field | Value |
|-------|-------|
| Scope | Single-environment lab with optional hybrid connectivity and private access. |
| Focus | Virtual WAN, secured hub, BGP, Route Server, private DNS, private endpoints. |
| IaC | Terraform >= 1.5 with AzureRM ~> 4.14. |
| Topology | 1 vWAN, 1 vHub (/23), 2 spokes, 1 on-prem simulation VNet. |
| Compute | Windows Server 2022 Core workload VMs and RRAS NVAs. |
| State | Local by default (see state guidance for remote options). |

## How to use this wiki

- If you are new: start with `book.md`, then the Architecture pages.
- If you want hands-on labs: follow Scenarios and then Testing.
- If you are changing the build: read Modules and Reference first.

## Documentation map

| Category | Articles |
|----------|----------|
| Book | [Book-style guide](book.md) |
| Architecture | [Overview](architecture/overview.md), [Network topology](architecture/network-topology.md), [vWAN and vHub](architecture/vwan-and-vhub.md), [Spokes and peerings](architecture/spokes-and-peerings.md), [Firewall and routing intent](architecture/firewall-and-routing-intent.md), [VPN and hybrid](architecture/vpn-and-hybrid.md), [Route Server and NVA](architecture/route-server-and-nva.md), [Edge services](architecture/edge-services.md), [Routing and BGP](architecture/routing-and-bgp.md), [Traffic flows](architecture/traffic-flows.md), [DNS and Private Link](architecture/dns-and-private-link.md), [Security model](architecture/security-model.md), [Configuration flow](architecture/configuration-flow.md), [Limitations and tradeoffs](architecture/limitations-and-tradeoffs.md) |
| Scenarios | [Scenarios overview](scenarios/README.md), [Virtual WAN basics](scenarios/vwan-basics.md), [Secured hub and firewall](scenarios/secured-hub-firewall.md), [VPN and BGP](scenarios/vpn-bgp.md), [Route Server and NVA](scenarios/route-server-bgp.md), [Private endpoints and DNS](scenarios/private-endpoints-dns.md), [Edge services](scenarios/edge-services.md), [Minimal cost lab](scenarios/minimal-cost.md), [Full lab build](scenarios/full-lab.md) |
| Modules | [Module design patterns](modules/README.md), [Networking modules](modules/networking.md), [Compute modules](modules/compute.md), [Security modules](modules/security.md), [Monitoring modules](modules/monitoring.md), [PaaS modules](modules/paas.md) |
| Reference | [Variables](reference/variables.md), [Outputs](reference/outputs.md), [Naming](reference/naming-conventions.md), [Terraform patterns](reference/terraform-patterns.md), [Feature matrix](reference/feature-matrix.md), [AZ-700 alignment](reference/az-700-alignment.md), [ASNs and IPs](reference/asn-and-ips.md), [Defaults and SKUs](reference/defaults-and-skus.md), [CLI cheat sheet](reference/cli-cheatsheet.md), [Ports and protocols](reference/ports-and-protocols.md), [Cost model](reference/cost-model.md), [Current config](reference/current-config.md), [Hardening checklist](reference/hardening.md), [State and secrets](reference/state-and-secrets.md), [Glossary](reference/glossary.md) |
| Testing | [Lab testing guide](testing/lab-testing-guide.md), [Component checks](testing/component-checks.md), [Route validation](testing/route-validation.md), [DNS validation](testing/dns-validation.md), [Test matrix](testing/test-matrix.md), [Troubleshooting](testing/troubleshooting.md) |

## Conventions and assumptions

- Single region, single environment, single state file.
- Optional components are controlled by the `deploy` object.
- Spoke1 cannot connect to vHub when Route Server is enabled (Azure limitation).
- Resource names derive from `ctx.project` (see naming conventions).

## Before you start

- Azure subscription with Owner or Contributor access.
- Terraform and Azure CLI installed.
- Budget awareness: vHub firewall, Route Server, VPN gateways, and App Gateway have ongoing costs.

## Where to go next

- New to the repo: read `book.md` and the Architecture overview.
- AZ-700 mapping: `reference/az-700-alignment.md`.
- Troubleshooting: start with `testing/troubleshooting.md`.
- Deep dive definitions: use `reference/glossary.md` and the Reference section.
