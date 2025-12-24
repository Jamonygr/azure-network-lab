# Azure Network Lab documentation

Azure Network Lab is a vWAN-centric Terraform lab that focuses on AZ-700 networking skills: Virtual WAN, secured hubs, BGP routing, private DNS, and private endpoints. The docs are written to be practical and to map directly to the Terraform code in this repository.

## Who this is for
- Cloud and network engineers who want a guided vWAN lab.
- Students preparing for AZ-700 who want real infrastructure to explore.
- Teams validating hub-and-spoke and hybrid routing patterns before production.

## What you will deploy
- Virtual WAN and a regional Virtual Hub.
- Optional Secured Hub (Azure Firewall) with routing intent.
- Optional vHub VPN Gateway plus an on-premises VPN gateway.
- Spoke VNets, NSGs, and optional peering.
- Azure Route Server with an RRAS NVA for BGP route injection.
- DNS Private Resolver and private DNS zones.
- Storage account with Private Endpoint.
- Windows Server workload VMs and NVA VMs.

## How to use these docs
1) Start with Architecture to understand the layout and design intent.
2) Use Scenarios to follow hands-on lab paths (vWAN, VPN, Route Server, Private DNS).
3) Review Modules to understand reusable building blocks.
4) Use Reference for variables, outputs, naming, and patterns.
5) Follow the Testing guide to validate your deployment.

## Article map

| Topic | What you will learn |
|-------|---------------------|
| [Book-style guide](book.md) | A-to-Z walkthrough of the repo flow and lab operations. |
| [Architecture overview](architecture/overview.md) | The major components and how they fit together. |
| [Network topology](architecture/network-topology.md) | Address spaces, subnets, and connectivity rules. |
| [Security model](architecture/security-model.md) | Firewall, NSGs, and guardrails in this lab. |
| [Configuration flow](architecture/configuration-flow.md) | How inputs flow through locals, modules, and outputs. |
| **Scenarios** ||
| [Scenarios overview](scenarios/README.md) | All lab scenarios in one place. |
| [Virtual WAN basics](scenarios/vwan-basics.md) | vWAN and vHub connectivity validation. |
| [Secured hub and firewall](scenarios/secured-hub-firewall.md) | Secured hub checks and routing intent. |
| [VPN + BGP](scenarios/vpn-bgp.md) | Site-to-site VPN and BGP validation. |
| [Route Server + NVA](scenarios/route-server-bgp.md) | Route Server peering with RRAS NVA. |
| [Private endpoints + DNS](scenarios/private-endpoints-dns.md) | Private DNS zones and storage private endpoint tests. |
| **Modules** ||
| [Module design patterns](modules/README.md) | Shared module conventions and ctx usage. |
| [Networking modules](modules/networking.md) | vWAN, vHub, VNets, NSGs, VPN, Route Server, DNS. |
| [Compute modules](modules/compute.md) | Windows VMs and RRAS NVA. |
| [Security modules](modules/security.md) | Firewall, NSGs, and access controls. |
| [Monitoring modules](modules/monitoring.md) | Log Analytics. |
| [PaaS modules](modules/paas.md) | Storage account and private endpoint. |
| **Reference** ||
| [Variables reference](reference/variables.md) | Inputs you set in `terraform.tfvars`. |
| [Outputs reference](reference/outputs.md) | Deployment outputs for testing and operations. |
| [Naming conventions](reference/naming-conventions.md) | Resource name patterns driven by `ctx`. |
| [Terraform patterns](reference/terraform-patterns.md) | HCL idioms used throughout this repo. |
| [Current config](reference/current-config.md) | Snapshot of the lab profile values. |
| [Hardening checklist](reference/hardening.md) | Steps to tighten security for the lab. |
| [State and secrets](reference/state-and-secrets.md) | State storage and secrets handling guidance. |
| **Testing** ||
| [Lab testing guide](testing/lab-testing-guide.md) | Step-by-step validation checklist. |

## Before you start
- Azure subscription with Owner or Contributor rights.
- Terraform 1.9 or later.
- Azure CLI signed in (`az login`).
- Budget awareness: vHub Firewall, Route Server, and VPN Gateway have hourly cost.
