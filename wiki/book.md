# Azure Network Lab - Book-Style Guide

This guide connects the Terraform code, network design, and testing steps into a single narrative. Read it top to bottom for the full picture, or jump to the sections that match what you are building or validating.

## How to read this guide
- Part 1 - Orientation: Repository layout, files, and baseline workflow.
- Part 2 - Terraform logic: Inputs, locals, module wiring, and optional features.
- Part 3 - Networking stack: vWAN, vHub, spokes, and routing choices.
- Part 4 - Hybrid and BGP: VPN gateways, Route Server, and RRAS NVA.
- Part 5 - DNS and Private Link: Private DNS zones and endpoints.
- Part 6 - Operating the lab: Apply, destroy, cost controls, and testing.

---

## Part 1 - Orientation

### Repository layout (top level)
- `main.tf` - root orchestrator; all resources are wired here (single environment).
- `locals.tf` - names, tags, subnet maps, and feature flags.
- `variables.tf` - input contract, validations, and safe defaults.
- `terraform.tfvars` - lab profile values (single environment).
- `outputs.tf` - connection info and key IDs.
- `modules/` - reusable building blocks (networking, compute, security).
- `wiki/` - documentation hub (this guide plus reference pages).

### Providers and state
- Provider: AzureRM 4.x.
- State: local by default (single state, single environment).
- No Terragrunt or workspaces; the lab uses one root module and one state file.

---

## Part 2 - Terraform logic flow

### Input -> locals -> modules -> outputs
1. Inputs: `terraform.tfvars` defines subscription, ctx, deploy flags, and credentials.
2. Locals: `locals.tf` creates the naming prefix, required tags, subnet maps, and filtered maps for `for_each`.
3. Modules: `main.tf` wires modules together using the shared `ctx` object.
4. Outputs: `outputs.tf` exposes key addresses and IDs for validation.

### Shared ctx object
All modules take a single `ctx` object:
- `project` drives naming.
- `location` sets region.
- `tags` are enforced and merged by the tags module.

### Optional components
Optional features are controlled by the `deploy` object. This lab uses `count` and `for_each` to create only what is enabled.

---

## Part 3 - Networking stack

### vWAN core
- Virtual WAN provides the global transit fabric.
- A regional Virtual Hub is created with a /23 prefix.
- Secured Hub is enabled when `deploy.vhub_firewall = true`.

### Spoke VNets
- Spoke1: Route Server, RRAS NVA, DNS resolver, optional App Gateway/Bastion/NAT/LB.
- Spoke2: Standard workload VNet connected to vHub.
- OnPrem: Simulated on-premises VNet with VPN gateway (optional).

### Connectivity rules
- Spoke2 connects to vHub when vWAN is enabled.
- Spoke1 connects to vHub only when Route Server is disabled (Azure limitation).
- Spoke1 and Spoke2 peer directly when Route Server is enabled.

---

## Part 4 - Hybrid and BGP

### Route Server path (Spoke1)
- Azure Route Server is deployed in Spoke1.
- RRAS NVA peers with Route Server using BGP ASN 65501.
- Route Server ASN is 65515.

### VPN path (OnPrem to vHub)
- vHub VPN Gateway terminates the S2S connection.
- OnPrem VNet runs a VPN gateway with BGP enabled.
- BGP ASN 65510 is used on the on-prem side.

---

## Part 5 - DNS and Private Link

### Private DNS zones
- `lab.internal` for internal host registration.
- `privatelink.blob.core.windows.net` for storage private endpoint.

### DNS Private Resolver
- Inbound and outbound endpoints are deployed in Spoke1.
- Use it to test private name resolution from spoke VNets.

### Private Endpoint
- Storage account is private by default; public access is disabled.
- Private endpoint lives in Spoke1 `PrivateEndpointSubnet`.

---

## Part 6 - Operating the lab

### Standard workflow
1. `terraform init`
2. `terraform plan -out=tfplan`
3. `terraform apply tfplan`
4. Validate with outputs and the testing guide.

### Cost controls
- Disable firewall, VPN, or Route Server when not needed.
- Reduce VM sizes for basic connectivity testing.
- Destroy the lab when idle.

### Testing
See `wiki/testing/lab-testing-guide.md` for a full validation checklist.
