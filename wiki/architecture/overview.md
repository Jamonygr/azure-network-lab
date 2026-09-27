# Architecture choices

The root is a configurable network teaching environment, not one mandatory large deployment. The default and [minimal profile](../../profiles/minimal.tfvars.example) keep the base VNets, subnets, NSGs and bidirectional spoke peering while excluding optional service instances. [Profiles](../reference/feature-matrix.md) select focused additions.

![vWAN secured-hub topology](../../docs/diagrams/vwan.svg)

*vWAN profile: Spoke1 and Spoke2 attach to the hub. Firewall inspection depends on routing intent and the selected route. The branch is another Azure VNet when the hybrid profile is selected.*

![Separate Route Server topology](../../docs/diagrams/route-server.svg)

*Route Server profile: BGP exchanges routes; application packets go between workload and NVA. Spoke1 is not attached to the vWAN hub when it contains Route Server.*

The legacy combined profile is retained for configuration review. It intentionally omits the Spoke1 hub connection. Do not infer a fully secured path for every VNet just because a Firewall exists elsewhere in the graph. [Microsoft Route Server constraints](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq)

Independent examples own separate resource groups and state. They do not wire themselves into this root. Use [the example index](../scenarios/independent-examples.md) for their scope.

Read [addressing](network-topology.md), [traffic paths](traffic-flows.md), [DNS](dns-and-private-link.md), and [limitations](limitations-and-tradeoffs.md) before claiming any connection is complete. All diagrams describe intended configuration; Azure acceptance and traffic are **NOT RUN**.
