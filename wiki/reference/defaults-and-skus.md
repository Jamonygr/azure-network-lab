# Defaults and SKUs

This page lists the key defaults and SKUs used across the lab. Values are drawn from module defaults and the root module wiring.

## Core networking

| Service | Default | Notes |
|---------|---------|-------|
| Virtual WAN | Standard | `type = "Standard"` |
| Virtual Hub | Standard | Address prefix from `var.vhub_address_prefix` |
| vHub Firewall | AZFW_Hub Standard | Firewall policy Standard, DNS proxy enabled |
| vHub VPN Gateway | Scale unit 1 | BGP ASN 65515 |
| Route Server | Standard | Zonal public IP |

## Edge services

| Service | Default | Notes |
|---------|---------|-------|
| Load Balancer | Standard | Internal, HTTP probe on port 80 |
| NAT Gateway | Standard | Zonal (zone 1), idle timeout 10 min |
| Application Gateway | WAF_v2 | WAF enabled (Detection), capacity 1 |
| Bastion | Basic | Standard SKU enables advanced features |

## VPN

| Service | Default | Notes |
|---------|---------|-------|
| OnPrem VPN Gateway | VpnGw1 | Route-based, BGP enabled |
| VPN Connection | IKEv2 | Shared key required |

## DNS and private access

| Service | Default | Notes |
|---------|---------|-------|
| DNS Private Resolver | Enabled by flag | Inbound/outbound endpoints in Spoke1 |
| Private DNS zones | `lab.internal`, `privatelink.blob.core.windows.net` | Linked to all VNets |
| Storage account | Standard LRS | TLS 1.2, public access disabled |

## Compute

| Service | Default | Notes |
|---------|---------|-------|
| Windows VMs | Server 2022 Datacenter Core | Small disk image |
| VM size | Standard_B2s | Override via `vm_size` |

## Notes

- Defaults can be overridden in the root module or `terraform.tfvars`.
- Check module `variables.tf` files for precise defaults.
