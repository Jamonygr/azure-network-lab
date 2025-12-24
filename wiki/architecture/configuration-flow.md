# Configuration flow

This page shows how values move from inputs to resources.

## 1) Inputs
- `terraform.tfvars` defines subscription ID, ctx, deploy flags, and credentials.
- Address spaces are set for vHub, spokes, and on-prem.

## 2) Locals
- `locals.tf` derives a prefix from `ctx.project`.
- Tag defaults and required keys are merged by the tags module.
- Maps define VNets, subnets, NSGs, VMs, and BGP connections.
- Filtered maps are used to drive `for_each` for optional resources.

## 3) Modules
- Root `main.tf` instantiates modules using the shared `ctx` object.
- Optional modules use `count` or filtered `for_each` maps.
- Dependencies are primarily expressed through module outputs.

## 4) Outputs
- `outputs.tf` exposes IPs, IDs, and connection details for testing.

## Key toggles
- `deploy.route_server` enables Route Server and NVA BGP.
- `deploy.vpn` enables on-prem VPN gateway and vHub VPN gateway.
- `deploy.private_endpoint` enables storage private endpoint (requires private DNS).

## Example flow: Route Server
1. `deploy.route_server = true` creates Route Server in Spoke1.
2. NVA module is enabled and receives Route Server IPs.
3. BGP peers are configured on the NVA via the VM extension.
4. vHub connection for Spoke1 is disabled to avoid conflicts.
