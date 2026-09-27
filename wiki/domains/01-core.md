# Domain 1 — Core networks

Use [minimal](../scenarios/minimal-cost.md) for address planning, [Route Server](../scenarios/route-server-bgp.md) for route distribution, and [private DNS](../scenarios/private-endpoints-dns.md) for name resolution. The independent [AVNM example](../../examples/avnm/README.md) adds centrally scoped configuration.

## Addressing decisions

Allocate nonoverlapping parent prefixes before assigning subnets. Keep an inventory of purpose, prefix, reserved platform name, delegation, route association, NSG association, and expected egress. A subnet reserved in Terraform is not evidence that its service is enabled. The [address diagram](../architecture/network-topology.md) preserves default root allocations; custom values must be checked against derived subnet math.

The [BYOIP exercise](../scenarios/design-exercises.md#byoip-and-public-prefixes) covers ownership and routing prerequisites without claiming the lab owns a public prefix. Separate a public prefix, an individual public IP, and the service using it.

## Routing decisions

For a selected destination, compare relevant system routes, propagated routes, and explicit UDRs. Identify the selected next hop at both ends. Peering is not automatically transitive. Route Server exchanges BGP routes; it does not forward application packets. The root separates Spoke1's Route Server attachment from a vWAN connection. [Routing explanation](../architecture/routing-and-bgp.md)

Explicit outbound behavior matters: new VNets created with APIs after 31 March 2026 default to private subnets; older APIs can retain the prior behavior. An intentional NAT, Firewall, or LB outbound design is easier to reason about than implicit egress. Existing VNets are not all disconnected by this change. [Microsoft default outbound guidance](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access)

## DNS and monitoring decisions

Draw the query path separately from the application path. A private DNS link provides namespace visibility; a ruleset link selects forwarding; neither creates IP connectivity to the resolved endpoint. For failures, record the client resolver, queried name, CNAME chain, final address, next hop, and service response.

Use [the monitoring chapter](../modules/monitoring.md) to decide between flow records, connection probes, logs, and resource health. Network Watcher and Defender answer different questions. The [Defender exercise](../scenarios/design-exercises.md#defender-investigation) uses clearly synthetic observations.

## Completion artifact

Produce an address ledger, two competing route choices, a DNS sequence diagram, and an evidence plan. Cite the selected profile and its state boundary. Use the [objective map](../reference/az-700-alignment.md) to identify uncovered design tasks.
