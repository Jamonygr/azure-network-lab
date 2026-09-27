# Networking modules

Core modules create resource groups, VNets, subnets, peerings, vWAN/hub connections, gateways, Route Server, NAT, delivery frontends and DNS components. [Generated interfaces](../../reference/README.md)

Root default/minimal creates Spoke1/Spoke2 bidirectional peering; the branch remains isolated. Route Server also selects spoke peering. vWAN profiles use hub connections rather than a direct inspection-bypass peer. Review the compatibility validations before combining flags.

DNS Private Resolver owns inbound/outbound endpoints and forwarding resources. Empty rules are inert configuration, not an external DNS server. The root private-zone links and endpoint zone group have separate purposes. [DNS architecture](../architecture/dns-and-private-link.md)

NAT covers enabled compute/NVA paths: Spoke1 workload/NVA association and conditional separate branch/Spoke2 services. It does not supersede an appliance route. [Traffic paths](../architecture/traffic-flows.md)

Gateway and Route Server outputs describe configuration endpoints; route exchange and packet delivery need independent checks. [BGP worksheet](../scenarios/route-server-bgp.md)
