# Azure Network Lab - Book-Style Guide

This guide connects the Terraform code, network design, and testing steps into a single narrative. It is intentionally detailed, so you can treat it like a book or a wiki: read it end-to-end or jump to the section you need.

## What this lab is

- A vWAN-centric lab that maps to AZ-700 topics.
- A single-environment Terraform deployment that creates real Azure resources.
- A safe place to explore hub-and-spoke, BGP, private DNS, and private endpoints.

## What this lab is not

- A multi-environment platform or landing zone.
- A production-ready, locked-down design.
- A complete security posture or monitoring baseline.

## How to read this guide

- Part 1 - Orientation: repository layout, prerequisites, and workflow.
- Part 2 - Terraform logic: inputs, locals, modules, and outputs.
- Part 3 - Core network: vWAN, vHub, firewall, spokes, and peerings.
- Part 4 - Hybrid and BGP: VPN gateways, Route Server, and RRAS NVA.
- Part 5 - DNS and Private Link: private DNS zones and endpoints.
- Part 6 - Edge and compute: App Gateway, LB, NAT, Bastion, VMs.
- Part 7 - Operations: apply/destroy, state, costs, and change control.
- Part 8 - Validation: scenarios and testing matrix.
- AZ-700 mapping: see `reference/az-700-alignment.md`.

---

## Part 1 - Orientation

### Repository layout (top level)

- `main.tf` - root orchestrator (single environment).
- `locals.tf` - naming, tags, subnet maps, and feature flags.
- `variables.tf` - input contract and validation.
- `terraform.tfvars` - lab profile values.
- `outputs.tf` - connection info and resource IDs.
- `modules/` - reusable building blocks.
- `wiki/` - documentation hub.

### Required tools

- Terraform >= 1.5 (see `providers.tf`).
- Azure CLI (for testing and validation).
- An Azure subscription with Owner or Contributor permissions.

### Cost awareness

The lab includes paid services (vHub firewall, VPN gateway, Route Server, DNS resolver, App Gateway). Use the `deploy` toggles to control cost and destroy the environment when idle.

---

## Part 2 - Terraform logic flow

### Input -> locals -> modules -> outputs

1. Inputs: `terraform.tfvars` defines subscription ID, `ctx`, deploy flags, and credentials.
2. Locals: `locals.tf` builds names, tags, subnet maps, and data-driven `for_each` maps.
3. Modules: `main.tf` wires modules using the shared `ctx` object.
4. Outputs: `outputs.tf` exposes key IDs and IPs for testing.

### Shared ctx object

Every module accepts a `ctx` object:

```hcl
ctx = {
  project  = "az700-lab"
  location = "eastus2"
  tags = {
    Environment = "lab"
    Project     = "az700"
  }
}
```

### Deploy flags

The `deploy` object acts as a control panel. Each flag toggles a service on or off. Optional resources are created with `count` or filtered `for_each` maps, which avoids drift when you switch features.

---

## Part 3 - Core network

### Virtual WAN and Virtual Hub

- vWAN is deployed with `type = Standard`.
- The vHub uses a /23 address prefix (default `10.10.0.0/23`).
- vHub connections are created for spokes when enabled.

### Secured hub (Azure Firewall)

When `deploy.vhub_firewall = true`, the lab creates:

- Azure Firewall in the vHub (hub SKU).
- A Firewall Policy with allow rules for lab traffic.
- Routing Intent for both Internet and private traffic.

### Spoke VNets

- Spoke1: Route Server, DNS resolver, NVA, edge services.
- Spoke2: Standard vHub-connected workload VNet.
- OnPrem: Simulated on-premises VNet with VPN gateway and optional NVA.

### VNet peering and limitations

- Spoke1 and Spoke2 peer directly when Route Server is enabled.
- Spoke1 does not connect to vHub when Route Server is enabled (Azure limitation).

---

## Part 4 - Hybrid and BGP

### VPN (on-prem to vHub)

- vHub VPN Gateway uses ASN 65515.
- OnPrem VPN Gateway uses ASN 65510 and connects via IPsec/IKEv2.
- The VPN site and gateway connection are built in vWAN.

### Route Server + RRAS NVA

- Azure Route Server is deployed in Spoke1 with branch-to-branch enabled.
- A Windows RRAS NVA in Spoke1 peers with Route Server (ASN 65501).
- BGP configuration is applied via a Custom Script extension.

---

## Part 5 - DNS and Private Link

### Private DNS zones

- `lab.internal` with auto-registration for spoke VNets.
- `privatelink.blob.core.windows.net` for storage private endpoints.

### DNS Private Resolver

Inbound and outbound endpoints live in Spoke1 subnets with DNS resolver delegation. Use this to test private resolution from spokes.

### Private Endpoint

Storage accounts are created with public access disabled. A private endpoint in Spoke1 links to the `privatelink.blob.core.windows.net` zone.

---

## Part 6 - Edge and compute

### Windows workload VMs

- Windows Server 2022 Core (small disk).
- Deployed across spokes and on-prem for connectivity tests.

### NVA VM (RRAS)

- IP forwarding enabled.
- Scheduled task ensures RRAS and BGP config at startup.

### Edge services

- Internal Load Balancer (HTTP probe on port 80).
- Application Gateway WAF v2 (Detection mode).
- NAT Gateway (Spoke1 workload subnet).
- Bastion (Basic SKU by default when enabled).

---

## Part 7 - Operations

### Workflow

1. `terraform init`
2. `terraform plan -out=tfplan`
3. `terraform apply tfplan`
4. Validate using the Testing docs.

### State and secrets

- State is local by default. Consider remote state for collaboration.
- Avoid storing secrets in git; use environment variables or a vault.

### Cost controls

- Disable firewall, VPN, Route Server, and App Gateway when not in use.
- Use small VM sizes for lab work.
- Destroy the lab when idle.

---

## Part 8 - Validation

Use the Testing pages for detailed validation steps:

- `testing/lab-testing-guide.md`
- `testing/component-checks.md`
- `testing/route-validation.md`
- `testing/dns-validation.md`
- `testing/test-matrix.md`
- `testing/troubleshooting.md`

Scenarios provide short, purpose-built lab paths:

- `scenarios/README.md`

---

## Appendix - Where to go next

- Architecture: `architecture/overview.md`
- Core fabric: `architecture/vwan-and-vhub.md`
- Security: `architecture/firewall-and-routing-intent.md`
- Reference: `reference/feature-matrix.md`
- Testing: `testing/component-checks.md`
- Glossary: `reference/glossary.md`
