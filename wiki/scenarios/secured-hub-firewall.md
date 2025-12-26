# Scenario: Secured hub and firewall

## Goal

Validate that Azure Firewall is deployed in the vHub and that routing intent is active for hub connections.

## Required toggles

- `deploy.vwan = true`
- `deploy.vhub_firewall = true`

## Steps

1. Apply the lab and capture outputs.
2. Confirm firewall and policy resources exist.
3. Verify vHub connections have Internet security enabled.

## Commands

```bash
# Firewall and policy
az network firewall show -g rg-<prefix> -n fw-vhub-<prefix> -o table
az network firewall policy show -g rg-<prefix> -n fwpol-<prefix> -o table

# vHub connections and security flag
az network vhub connection list -g rg-<prefix> --vhub-name vhub-<prefix> -o table
```

## Expected results

- Firewall exists and is in Succeeded state.
- Firewall policy exists with a rule collection group.
- vHub connections show `InternetSecurityEnabled` as true.

## Notes

- Replace `<prefix>` with `ctx.project`.
- Traffic inspection behavior depends on routing intent, which is created by the firewall module.
- Use the testing guide for connectivity checks: `../testing/lab-testing-guide.md`.
