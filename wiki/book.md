# A five-domain Azure networking course

This book asks you to explain a network before operating one. For each chapter: draw the packet path, identify the required configuration, predict the failure mode, and specify evidence that could falsify your prediction.

**No labs were deployed or executed for this repository update.** Every Azure command in this book and linked exercises is a future operator reference. You can complete address planning, configuration review, diagram reading, and synthetic evidence interpretation without an Azure account.

## Chapter 1 — Core networks, 25–30%

Read [core networking](domains/01-core.md), [address allocation](architecture/network-topology.md), and [DNS](architecture/dns-and-private-link.md). Inspect the minimal profile, then compare Route Server and vWAN as separate topologies. Explain why a DNS answer does not establish a route, why a route does not grant service authorization, and why a BGP session is not a data-path test.

Exercises: [minimal footprint](scenarios/minimal-cost.md), [Route Server](scenarios/route-server-bgp.md), [private DNS](scenarios/private-endpoints-dns.md), and [AVNM](scenarios/independent-examples.md#avnm). Submit an address plan, a forward/return route table, and one resolved-name chain.

## Chapter 2 — Connectivity, 20–25%

Read [connectivity](domains/02-connectivity.md). The [hybrid VPN](scenarios/vpn-bgp.md) represents a branch with another Azure VNet. It does not prove interoperability with an external VPN appliance. Pair the [P2S example](../examples/point-to-site-vpn/README.md) with the [ExpressRoute and external VPN design exercises](scenarios/design-exercises.md).

Submit failure-domain diagrams, the prefixes each side should advertise, an authentication decision record, and an explanation of where encryption begins and ends.

## Chapter 3 — Application delivery, 15–20%

Read [delivery](domains/03-delivery.md). Trace DNS selection, TCP flow, TLS termination, WAF evaluation, origin health, and the return path separately. Complete [edge services](scenarios/edge-services.md), [Traffic Manager](../examples/traffic-manager/README.md), and [Front Door](../examples/front-door-private-origin/README.md) configuration reviews.

Submit a service-selection table, an end-to-end certificate/name checklist, and expected behavior when an origin becomes unhealthy. A configured listener with no serving backend is not a working application.

## Chapter 4 — Private access, 10–15%

Read [private access](domains/04-private-access.md). Contrast a consumer private endpoint with a service endpoint reaching the service's public endpoint. Review [Private Link service](../examples/private-link-service/README.md) and [endpoint policy](../examples/service-endpoint-policy/README.md). Separate DNS, routing, firewall policy, endpoint approval, and data-plane RBAC.

Submit positive and negative test pairs using the same authorized identity. An authorization failure alone does not prove a network restriction.

## Chapter 5 — Network security, 15–20%

Read [security](domains/05-security.md), [monitoring](modules/monitoring.md), and [the evidence matrix](testing/test-matrix.md). Compare subnet NSGs, ASGs, AVNM administration, routed Firewall policy, WAF rules, and DDoS protection. Work through [Defender design interpretation](scenarios/design-exercises.md#defender-investigation).

Submit a least-privilege access table, synthetic flow-record interpretation, and a rollback procedure for one deliberate configuration fault. Never generate an attack to test a DDoS plan.

## Instructor use

Choose one profile or example per session. Assign a reader to routing, one to DNS, and one to policy; have them independently predict the same connection before comparing conclusions. Grade evidence quality rather than screenshots of a green deployment badge.

Use these exit questions for every exercise:

1. What resource or input implements the objective?
2. What required dependency is outside this configuration?
3. Which record proves the request path and which proves the response?
4. What other failure could produce the same symptom?
5. What resources continue billing while the VM is stopped?
6. Which exact root and state own cleanup?

The [136-row coverage matrix](reference/az-700-alignment.md) is a navigation aid. It explicitly distinguishes implemented configuration, reference material, and design-only topics. [Official exam scope](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700)
