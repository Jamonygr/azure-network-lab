# Scenario: Virtual WAN basics

## Goal
Validate that Virtual WAN and the Virtual Hub are deployed and that spokes connect as expected.

## Required toggles
- `deploy.vwan = true`
- `deploy.vhub_firewall` can be either true or false

## Steps
1. Apply the lab and capture outputs.
2. Confirm vWAN and vHub exist.
3. Verify vHub connections for spokes.

## Commands
```bash
# vWAN and vHub
az network vwan show -g rg-az700-lab -n vwan-az700-lab -o table
az network vhub show -g rg-az700-lab -n vhub-az700-lab -o table

# vHub connections
az network vhub connection list -g rg-az700-lab --vhub-name vhub-az700-lab -o table
```

## Expected results
- vWAN and vHub are in Succeeded state.
- Spoke2 is connected to vHub when vWAN is enabled.
- Spoke1 connects only when Route Server is disabled.
