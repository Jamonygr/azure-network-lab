# Root profiles and ownership

All files below are committed nonsecret `.tfvars.example` overlays. Terraform accepts them with an explicit `-var-file`. They do not isolate state.

| Profile | Enabled optional flags |
|---|---|
| [minimal](../../profiles/minimal.tfvars.example) | spoke_peering; no optional paid services |
| [vwan-secured](../../profiles/vwan-secured.tfvars.example) | vwan, vhub_firewall, log_analytics |
| [hybrid-vpn](../../profiles/hybrid-vpn.tfvars.example) | vwan, vpn, log_analytics |
| [route-server](../../profiles/route-server.tfvars.example) | route_server, nvas, nat_gateway |
| [private-dns](../../profiles/private-dns.tfvars.example) | dns_resolver, private_dns_zones, private_endpoint |
| [application-delivery](../../profiles/application-delivery.tfvars.example) | application_gateway, load_balancer, nat_gateway, spoke1_vms |
| [legacy-combined](../../profiles/legacy-combined.tfvars.example) | Earlier broad footprint, Bastion off, Log Analytics on |

Monitoring is off in all shipped profiles. Log Analytics alone does not mean diagnostics or flow logs are configured. See [monitoring opt-in](variables.md#monitoring-settings).

The root always owns three VNets, reserved subnets and NSGs. Direct spoke peering occurs in minimal and Route Server modes. That mode removes Spoke1's hub connection. Optional paid services are absent from minimal.

Each independent example is another root. None is implicitly connected to these VNets. [Examples](../scenarios/independent-examples.md)
