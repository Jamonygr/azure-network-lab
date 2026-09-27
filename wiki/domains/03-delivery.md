# Domain 3 — Application delivery

Start with [edge services](../scenarios/edge-services.md), then compare [Traffic Manager](../../examples/traffic-manager/README.md) and [Front Door with a private origin](../../examples/front-door-private-origin/README.md). Use the [delivery diagram](../architecture/edge-services.md) to keep name resolution and proxying distinct.

| Service | Decision it makes | What it does not establish |
|---|---|---|
| Traffic Manager | Which endpoint name/address DNS returns | It does not proxy the subsequent application connection |
| Standard Load Balancer | Which healthy transport backend receives a flow | It does not inspect HTTP paths or terminate TLS |
| Application Gateway | Regional HTTP routing, TLS and WAF evaluation | A listener cannot make an empty or failing backend healthy |
| Front Door | Global HTTP delivery and origin selection | Origin Private Link does not make its client-facing endpoint private |
| Gateway Load Balancer | Appliance insertion and flow handling | A usable NVA implementation/licensing is not supplied by a diagram |

## Configuration review

For the root, inspect the backend pool, frontend/listener, rule, probe, backend protocol and port as a chain. Check host headers and certificates for both TLS legs. Treat optional HTTPS inputs as reference configuration until the certificate identity, secret permissions, DNS names and origin service are supplied.

Traffic Manager makes a DNS decision affected by TTL and client caching; a failure does not instantly move every client. For Front Door, explain endpoint, route, origin group, health probe, WAF association, cache behavior, rewrite/redirect, and manual Private Link approval.

App Gateway v1 retired on 28 April 2026; the repository uses WAF_v2. TLS examples must use supported policies and TLS 1.2 or later. [v1 retirement](https://learn.microsoft.com/en-us/azure/application-gateway/v1-retirement), [TLS guidance](https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-tls-version-retirement)

Front Door examples use Standard/Premium-era resources. Classic retires on 31 March 2027 and is not an appropriate new example. [Retirement FAQ](https://learn.microsoft.com/en-us/azure/frontdoor/classic-retirement-faq)

## Completion artifact

Compare one regional and one global architecture for availability, protocols, client IP visibility, certificates, private origin access, caching, and cost. Write a health-probe failure hypothesis and identify the diagnostic field needed to distinguish it from an NSG denial.
