# Domain 4 — Private access

Work through [private DNS and endpoints](../scenarios/private-endpoints-dns.md), [Private Link service](../../examples/private-link-service/README.md), and [service endpoint policy](../../examples/service-endpoint-policy/README.md).

## Distinguish the paths

A private endpoint is a consumer-side network interface with a private address. Its connection targets a service/subresource and can require approval. DNS must lead the client to the intended address, and the client must have a route to it. Data permissions remain necessary.

A service endpoint uses a supported Azure service's public endpoint while identifying the source subnet. An endpoint policy restricts selected service destinations; it does not turn that endpoint into a private IP. The example grants the client comparable read access to two storage accounts so a later network-policy comparison is not confused with RBAC. [Service endpoint policies](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoint-policies-overview)

A Private Link service is the provider side of a custom service behind a Standard internal load balancer. The independent example includes its producer and consumer configuration. Network reachability and connection approval still need separate evidence. [Private Link service](https://learn.microsoft.com/en-us/azure/private-link/private-link-service-overview)

## Review in layers

1. Confirm the target service and subresource.
2. Trace public name, CNAME and private record.
3. Check endpoint approval and zone links.
4. Select a client with a supported route and DNS path.
5. Compare route and network policy with data-plane authorization.
6. Pair an authorized private-path success with a public-path denial where that restriction is configured.

Do not use a failed request by an unauthenticated user as proof that public access is disabled. Do not describe a successful DNS query as proof that the storage operation succeeds.

## Completion artifact

Produce a two-column private-endpoint/service-endpoint comparison, a hybrid DNS sequence, and a test record template containing client, identity, name, IP, path, timestamp and expected result. The [DNS testing guide](../testing/dns-validation.md) gives future diagnostic commands; no such command was executed for this update.
