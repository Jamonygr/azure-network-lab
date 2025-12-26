# Scenario: Route Server and NVA (BGP)

## Goal

Validate that Azure Route Server is deployed and that the RRAS NVA peers via BGP.

## Required toggles

- `deploy.route_server = true`
- `deploy.nvas = true`

## Steps

1. Apply the lab and capture outputs.
2. Confirm Route Server is deployed in Spoke1.
3. Verify BGP peer entries on the Route Server.
4. Validate BGP peer status on the NVA.

## Commands

```bash
# Route Server and peers
az network routeserver show -g rg-<prefix> -n rs-<prefix> -o table
az network routeserver peering list -g rg-<prefix> --routeserver rs-<prefix> -o table

# NVA BGP peers
az vm run-command invoke -g rg-<prefix> -n vm-spoke1-nva \
  --command-id RunPowerShellScript \
  --scripts "Get-BgpPeer | Format-Table Name,PeerIPAddress,PeerASN,State,SessionState"
```

## Expected results

- Route Server is in Succeeded state.
- Peering entries exist for the NVA.
- NVA shows BGP peers in Connected state.

## Notes

- Replace `<prefix>` with `ctx.project`.
- Spoke1 is not connected to vHub when Route Server is enabled.
- Route Server uses ASN 65515; NVA uses ASN 65501.
