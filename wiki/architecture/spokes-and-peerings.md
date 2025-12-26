# Spokes and peerings

This page covers the VNets, subnet layout, NSGs, and VNet peerings that define the spoke layer.

## Spoke VNets

The lab creates three VNets using `modules/vnet`:

- Spoke1: route server, DNS resolver, NVA, edge services.
- Spoke2: workload-only spoke connected to the vHub.
- OnPrem: simulated on-premises network for VPN testing.

Address spaces are defined in `locals.tf` and can be overridden via `terraform.tfvars`.

## Subnet behaviors and special cases

- `PrivateEndpointSubnet` disables private endpoint network policies.
- DNS resolver subnets include delegation to `Microsoft.Network/dnsResolvers`.
- Spoke2 Workload subnet includes a Storage service endpoint.

## NSGs

NSGs are defined in `locals.tf` and applied to workload and NVA subnets:

- Spoke1: Workload and NvaSubnet.
- Spoke2: Workload.
- OnPrem: Default and NvaSubnet.

Baseline rules allow RDP, HTTP, HTTPS, and ICMP for lab testing.

## VNet peering

Spoke1 and Spoke2 are peered when Route Server is enabled:

- `allow_forwarded_traffic = true`
- `allow_gateway_transit = false`
- `use_remote_gateways = false`

This provides direct connectivity when Spoke1 cannot connect to the vHub.

## Related pages

- Subnet map: `architecture/network-topology.md`
- Routing constraints: `architecture/limitations-and-tradeoffs.md`
