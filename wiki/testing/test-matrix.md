# Evidence matrix

Current live status for every row is **NOT RUN**. Predictions below are not test results.

| Area | Local evidence | Future live evidence | Insufficient by itself |
|---|---|---|---|
| Minimal | CIDR/flag/peering assertions | Intended resources and effective connectivity | VNet object exists |
| vWAN | Connection/intent graph | Selected routes both directions | Hub resource is green |
| Firewall | Rule targets and scopes | Exact allow/deny log matching a request | Timeout or no DNS answer |
| VPN | Peer/connection inputs | IKE/IPsec, BGP, application response | Tunnel established |
| Route Server | Peer and synthetic-route configuration | Both BGP sessions and accepted prefixes | Ping to a nonexistent advertised destination |
| Private DNS | Zone/link/rule references | Client query chain and endpoint address | Query run from unrelated resolver |
| Private endpoint | Public settings and connection target | Approved endpoint and authorized operation | Unauthenticated 403 |
| App Gateway/LB | Backend/probe/listener wiring | Backend health and served response | Listener exists |
| Front Door | Route/origin/policy | Approved private origin, healthy request | Profile creation |
| Traffic Manager | Routing/endpoint definitions | DNS answer plus selected endpoint response | Valid HTTPS assumed on trafficmanager.net name |
| Service endpoint policy | Policy scope and equal test roles | Allowed/denied destination pair | Different identities or permissions |
| P2S | Client pool and Entra parameters | Real client sign-in, routes and traffic | Gateway deployment |
| DDoS | Plan association and alerts | Configuration/metric evidence, without attack generation | Claim of simulated mitigation |
| Monitoring | Targets, destination and retention | Arriving records with matching schema/time | Workspace alone |

Each result should be PASS, FAIL, SKIP (with reason), or NOT RUN. Avoid substituting mocked output for a live screenshot or using an absent external client as a pass. [Evidence contract](lab-testing-guide.md)
