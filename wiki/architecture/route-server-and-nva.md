# Route Server and NVA

![BGP control plane separated from application traffic](../../docs/diagrams/route-server.svg)

*Dashed BGP edges represent control-plane exchange. Solid traffic edges go through the NVA, not Route Server. A synthetic advertised prefix is not a real destination network.*

The root uses Route Server in Spoke1 and an RRAS NVA for the routing exercise. The selected profile also creates a branch NVA, without an inter-NVA tunnel, and selects no workload VMs. The default teaching ASN is 65501 for the NVA; Route Server uses the Azure ASN exposed by its output. An advertised `10.100.0.0/16` demonstrates route learning and does not create a reachable workload in that prefix.

Review the NVA extension/template, IP forwarding, BGP peers and local operating-system configuration. Terraform declaring a peer is not proof that RRAS successfully configured or established both sessions. The complete topology should peer an NVA with both Route Server instances for resilience. [Microsoft guidance](https://learn.microsoft.com/en-us/azure/route-server/route-server-faq)

The Route Server VNet cannot simultaneously connect to a vWAN hub. The root's omitted Spoke1 connection is intentional. Explain peering flags and learned-route behavior separately; do not infer them from a simple line in a diagram.

Use the [Route Server exercise](../scenarios/route-server-bgp.md) and [route validation worksheet](../testing/route-validation.md). Guest bootstrapping, BGP state and data traffic remain NOT RUN.
