# Future route diagnosis

These commands query a live environment and were **NOT RUN**. Select a known source NIC in a separately authorized deployment; confirm account and identifiers first.

```powershell
# Replace placeholders with the exact source NIC and resource group.
az network nic show-effective-route-table --resource-group '<lab-rg>' --name '<source-nic>' --output table
az network nic list-effective-nsg --resource-group '<lab-rg>' --name '<source-nic>' --output json
```

For the chosen destination, write every relevant candidate prefix, route source, next hop and selection rationale. Repeat from the destination toward the original or translated source. Consider source NAT before deciding what the return route needs.

For BGP, record both Route Server peer sessions and learned/advertised prefixes. The root's synthetic 10.100.0.0/16 advertisement demonstrates control-plane learning; there is no endpoint there to prove a data path. Neither NVA presence nor direct peering proves branch transit.

A future Network Watcher IP-flow check can distinguish a named NSG rule result:

```powershell
az network watcher test-ip-flow --resource-group '<lab-rg>' --vm '<source-vm>' --direction Outbound --protocol TCP --local '<source-private-ip>:50000' --remote '<destination-ip>:443'
```

This evaluates a specific flow condition; it is not a full application request or a Firewall-policy test. If a command requires an extension, install it deliberately after review, never by assuming the offline runner needs Azure tooling.

Use [traffic diagrams](../architecture/traffic-flows.md) and preserve timestamps for correlation.
