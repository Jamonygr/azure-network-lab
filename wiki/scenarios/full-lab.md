# Scenario: Full lab build

## Goal

Deploy all optional components to exercise the full range of AZ-700 topics in this repo.

## Suggested toggles

```hcl
deploy = {
  vwan          = true
  vhub_firewall = true
  vpn           = true
  route_server  = true

  dns_resolver      = true
  private_dns_zones = true
  bastion           = true

  application_gateway = true
  load_balancer       = true
  nat_gateway         = true

  private_endpoint = true

  spoke1_vms = true
  spoke2_vms = true
  onprem_vms = true
  nvas       = true
}
```

## Steps

1. Apply the lab and wait for all gateways to finish provisioning.
2. Validate vWAN, vHub, firewall, and connections.
3. Validate Route Server BGP and VPN connectivity.
4. Validate DNS and private endpoints.
5. Validate edge services (ILB, NAT, App Gateway, Bastion).

## Commands

```bash
# Core
az network vhub show -g rg-<prefix> -n vhub-<prefix> -o table
az network firewall show -g rg-<prefix> -n fw-vhub-<prefix> -o table

# Route Server
az network routeserver show -g rg-<prefix> -n rs-<prefix> -o table

# VPN
az network vpn-connection show -g rg-<prefix> -n conn-onprem-to-vhub-<prefix> -o table
```

## Expected results

- All core resources are in Succeeded state.
- Route Server peers show Connected.
- VPN connection is Connected.
- Private endpoint resolves to a private IP.

## Notes

- This profile is the highest cost and can take the longest to provision.
- Spoke1 will not connect to the vHub when Route Server is enabled.
