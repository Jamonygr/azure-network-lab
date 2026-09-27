# Firewall and routing intent

The secured hub has three separate concerns: a Firewall instance, its policy/rule collections, and routing intent selecting that Firewall for relevant traffic. Review all three. The profile's configured FQDN allowlist is the starting point for outbound application rules; adding `*` would broaden its meaning.

A useful review table is:

| Flow | Required path | Policy question | Evidence |
|---|---|---|---|
| Spoke to Internet HTTPS | Spoke connection, hub, Firewall, destination | Does an application rule match the hostname and port? | Effective route plus application-rule log |
| Spoke to spoke | Hub inspection path in this profile | Is the private destination/port allowed? | Forward and reverse route, network-rule log |
| Branch to spoke | VPN, hub, destination VNet | Do route propagation and network rules agree? | Tunnel/BGP records and correlated flow |
| Private endpoint | Route to endpoint IP | Does the actual route cross Firewall? | Selected route; endpoint and service evidence |

Do not assume all traffic crosses the Firewall. More specific paths, direct peering, local subnet traffic, and profile selection can change the answer. A NAT Gateway does not override a route that already sends traffic to a virtual appliance.

Use [traffic paths](traffic-flows.md) and [secured hub exercise](../scenarios/secured-hub-firewall.md). All enforcement checks remain NOT RUN.
