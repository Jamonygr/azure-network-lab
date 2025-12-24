# Architecture overview

Azure Network Lab deploys a vWAN-centric topology for AZ-700 practice. The design focuses on core routing and security patterns: secured hubs, VPN with BGP, Route Server with RRAS NVA, and private DNS/Private Link.

## Core components

| Component | Purpose |
|-----------|---------|
| Virtual WAN | Global transit fabric for hub-and-spoke routing. |
| Virtual Hub | Regional hub (default /23 prefix). |
| Secured Hub (Firewall) | Centralized security inspection and routing intent. |
| vHub VPN Gateway | Terminate site-to-site VPN connections (optional). |
| Route Server | BGP route injection to/from NVAs (optional). |
| Spoke VNets | Workload isolation and routing tests. |
| DNS Resolver + Private DNS | Private name resolution for spokes (optional). |
| Private Endpoint | Storage private connectivity (optional). |
| Windows VMs | Workload and NVA hosts for testing. |

## Default lab profile (terraform.tfvars)

| Flag | Default | Notes |
|------|---------|-------|
| `deploy.vwan` | `true` | vWAN and vHub are created. |
| `deploy.vhub_firewall` | `true` | Secured Hub enabled. |
| `deploy.vpn` | `false` | VPN off by default. |
| `deploy.route_server` | `true` | Route Server + NVA enabled. |
| `deploy.private_dns_zones` | `true` | Required for storage private endpoint. |
| `deploy.dns_resolver` | `true` | Inbound/outbound endpoints in Spoke1. |
| `deploy.private_endpoint` | `true` | Storage private endpoint enabled. |
| `deploy.application_gateway` | `false` | WAF v2 App Gateway off by default. |
| `deploy.load_balancer` | `true` | Internal LB for Spoke1 workload. |
| `deploy.nat_gateway` | `true` | NAT for Spoke1 workload subnet. |
| `deploy.bastion` | `false` | Bastion off by default. |

## Design constraints
- Single environment (lab) with one state file.
- Root module is the orchestrator; child modules have no provider blocks.
- All modules consume a shared `ctx` object (project, location, tags).
- Optional components are controlled by the `deploy` object.

## Key behaviors
- Spoke1 is not connected to vHub when Route Server is enabled (Azure limitation).
- Spoke1 and Spoke2 peer directly when Route Server is enabled.
- Storage account public access is disabled; access is via private endpoint.
