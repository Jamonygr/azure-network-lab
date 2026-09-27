# Spokes and peering

Spoke1 contains service subnets and optional workloads. Spoke2 provides another network boundary. The branch VNet simulates an on-premises address space inside Azure.

In the vWAN shape, eligible spokes use hub connections. In minimal and Route Server shapes, the root uses direct Spoke1/Spoke2 peering; the minimal branch stays isolated. Check both directions of each peering: access, forwarded traffic, gateway transit and use of remote gateways are independent properties. A bidirectional peering is not proof that learned routes propagate into both VNets.

Peering does not create transitive connectivity through an unrelated peer. Write down the required return route and the owner of each hop before drawing a transit arrow. Keep the selected configuration's peer flags visible in the [route worksheet](../testing/route-validation.md).

[Topology diagrams](overview.md) distinguish these shapes. The [AVNM example](../../examples/avnm/README.md) uses its own VNets and static membership; it does not take over these root peerings.
