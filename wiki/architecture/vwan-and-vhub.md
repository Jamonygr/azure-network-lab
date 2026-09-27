# Virtual WAN and the secured hub

![vWAN configuration](../../docs/diagrams/vwan.svg)

*The hub router connects VNets. When enabled, Firewall and routing intent describe inspection for Internet and private destinations. The VPN branch is optional.*

The root's `deploy.vwan` enables vWAN, vHub and eligible VNet connections. `deploy.vhub_firewall` requires vWAN. `deploy.vpn` adds the hub VPN gateway and an Azure gateway in the simulated branch. Read the selected profile rather than combining every flag.

Inspect `modules/vhub-connection` for connection settings and `modules/vhub-firewall` for routing intent. The latter references the Firewall as a next hop for private and Internet categories. A permissive policy and a missing route are different defects: one changes what traffic is allowed, the other changes whether it reaches inspection.

For a future verification, obtain the connection's effective routes and correlate a source/destination test with Firewall logs. Do not use the presence of a policy resource as evidence of enforcement. Also review reverse routes for branch and spoke traffic.

When Route Server is enabled in Spoke1, the root removes that VNet's hub connection. The [Route Server design](route-server-and-nva.md) is a separate learning path. See [secured hub exercise](../scenarios/secured-hub-firewall.md).
