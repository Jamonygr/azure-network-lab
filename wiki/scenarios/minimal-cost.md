# Scenario: Minimal cost lab

## Goal

Deploy a lightweight lab profile for basic vWAN and spoke connectivity while minimizing paid services.

## Suggested toggles

```hcl
deploy = {
  vwan          = true
  vhub_firewall = false
  vpn           = false
  route_server  = false

  dns_resolver      = false
  private_dns_zones = false
  bastion           = false

  application_gateway = false
  load_balancer       = false
  nat_gateway         = false

  private_endpoint = false

  spoke1_vms = true
  spoke2_vms = true
  onprem_vms = false
  nvas       = false
}
```

## Steps

1. Apply the lab and capture outputs.
2. Validate vWAN, vHub, and vHub connections.
3. Test basic connectivity between spokes.

## Commands

```bash
az network vwan show -g rg-<prefix> -n vwan-<prefix> -o table
az network vhub show -g rg-<prefix> -n vhub-<prefix> -o table
az network vhub connection list -g rg-<prefix> --vhub-name vhub-<prefix> -o table
```

## Expected results

- vWAN and vHub are in Succeeded state.
- Spoke1 and Spoke2 are connected to the hub.

## Notes

- This profile skips paid services like Firewall, VPN, Route Server, DNS resolver, and App Gateway.
- Add optional services as needed for deeper tests.
