# Route validation

Use these checks to validate routing and next-hop behavior. Replace `<prefix>` with your `ctx.project`.

## Get VM and NIC IDs

```bash
vm_id=$(az vm show -g rg-<prefix> -n vm-spoke1-1 --query id -o tsv)
nic_id=$(az vm show -g rg-<prefix> -n vm-spoke1-1 --query "networkProfile.networkInterfaces[0].id" -o tsv)
```

## Effective routes

```bash
az network nic show-effective-route-table --ids $nic_id -o table
```

Expected:

- Routes to spoke and on-prem address spaces appear when connectivity is enabled.
- Next hop may show `VirtualNetworkPeering`, `VirtualNetworkGateway`, or `Internet` depending on the scenario.

## Next hop test

```bash
az network watcher show-next-hop \
  --source-resource $vm_id \
  --dest-address 10.2.1.4 \
  --dest-port 3389 -o table
```

Expected:

- Next hop should resolve to `VirtualNetworkPeering` or `VirtualNetworkGateway` depending on the active topology.

## vHub connection status

```bash
az network vhub connection list -g rg-<prefix> --vhub-name vhub-<prefix> -o table
```

## Notes

- Network Watcher may be required for next-hop tests in some regions.
- When Route Server is enabled, Spoke1 routes to Spoke2 via peering.
- When Route Server is disabled, Spoke1 routes to Spoke2 via the vHub.
