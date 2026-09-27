# Security model

The configuration separates network controls from identity and service controls. An NSG rule cannot authorize a Blob read; an RBAC role cannot supply a missing private route. An endpoint approval is another independent decision.

| Layer | Main configuration/evidence |
|---|---|
| Scope and identity | Correct tenant/subscription, RBAC permissions, resource ownership |
| Routing | Effective route and return route; real traversal of inspection device |
| Network filtering | NSG/ASG, AVNM administration, Firewall rules |
| Application filtering | WAF policy association, mode and matched rule |
| Private service boundary | Endpoint approval, private DNS, public-network setting |
| Data authorization | Authorized request using the intended identity |
| Detection | Flow records, diagnostics, probes and resource health |

Least-privilege review starts with explicit administration sources and an explicit outbound list. Do not add broad Internet RDP or wildcard egress to make a test appear successful. Changes to a profile can affect multiple services and their cost.

State and saved plans may contain secrets even when outputs are marked sensitive. Follow [state handling](../reference/state-and-secrets.md) and [SECURITY.md](../../SECURITY.md). Live enforcement, real identity permissions and external connectivity remain NOT RUN.
