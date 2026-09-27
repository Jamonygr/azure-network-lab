# Routing and BGP reasoning

A useful routing explanation names a source interface, destination prefix, route source, selected next hop and return route. `BGP established` only describes a session; it does not say a desired prefix was advertised, accepted or selected.

For the root, compare three cases: hub-attached spoke traffic, direct peering in the Route Server profile, and VPN-connected branch traffic. Use [the diagram](traffic-flows.md) to show which device forwards packets. Route Server distributes routes rather than carrying the application flow.

Create a candidate-route table with prefix length, origin and next hop. Explain overlaps before applying a simplistic UDR/BGP/system precedence mnemonic: Azure has special treatment for platform routes and service paths. Validate the effective route for the exact destination. Never advertise a default route as an incidental troubleshooting shortcut.

The synthetic NVA prefix is useful for checking route presence, but it has no deployed backend. A missing ping response from it is not automatically a BGP failure.

For a future incident, correlate route tables and BGP observations with firewall/NSG and guest evidence at the same timestamp. [Route validation](../testing/route-validation.md)
