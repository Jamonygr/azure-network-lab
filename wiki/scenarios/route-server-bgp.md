# Scenario: Route Server + NVA (BGP)

## Goal
Validate Azure Route Server peering with the RRAS NVA in Spoke1.

## Required toggles
- `deploy.route_server = true`
- `deploy.nvas = true`

## Steps
1. Confirm Route Server deployment.
2. Check BGP peering connections.
3. Validate BGP peers on the NVA VM.

## Commands
```bash
# Route Server and peering
az network routeserver show -g rg-az700-lab -n rs-az700-lab -o table
az network routeserver peering list -g rg-az700-lab --routeserver rs-az700-lab -o table

# BGP on the NVA (RunCommand)
az vm run-command invoke -g rg-az700-lab -n vm-spoke1-nva \
  --command-id RunPowerShellScript \
  --scripts "Get-BgpPeer | Format-Table Name,PeerIPAddress,PeerASN,State,SessionState"
```

## Expected results
- Route Server is Succeeded.
- BGP peering entries exist for the NVA.
- `Get-BgpPeer` shows peers for the Route Server IPs.
