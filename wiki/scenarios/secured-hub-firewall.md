# Scenario: Secured hub and firewall

## Goal
Validate Secured Hub deployment and firewall plumbing in the vHub.

## Required toggles
- `deploy.vwan = true`
- `deploy.vhub_firewall = true`

## Steps
1. Confirm firewall and policy exist.
2. Check that the vHub is in secured mode.
3. Verify firewall public IPs are present.

## Commands
```bash
az network firewall show -g rg-az700-lab -n fw-vhub-az700-lab -o table
az network firewall policy show -g rg-az700-lab -n fwpol-az700-lab -o table
az network vhub show -g rg-az700-lab -n vhub-az700-lab --query "routingIntent" -o json
```

## Expected results
- Firewall and policy are Succeeded.
- vHub routing intent is present.
- Firewall public IPs are returned in outputs.
