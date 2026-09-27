# Future component checks

These are future operator references. **No Azure component was queried or exercised.**

| Component | Inspect before testing | Request/evidence |
|---|---|---|
| Hub | Connection association, propagation and intent | Effective routes in both directions |
| Firewall | Rules, source scope, diagnostics | Allowed/denied request with matching rule log |
| VPN | Negotiated policy, peer and routes | Tunnel/BGP records plus host response |
| NVA | Extension, forwarding and both BGP peers | Guest command results and route records |
| DNS | Client resolver, zone/ruleset links | Normal hostname CNAME/A chain |
| Endpoint | Target/subresource, approval, public setting | Authorized service request |
| App Gateway | Listener, hostname, backend and probe | Backend health plus response |
| LB | Pool, rule, probe and NSG | Real service response from private client |
| Monitoring | Existing watcher, targets, retention, agent | New records with the expected source/time |

Example future App Gateway inspection:

```powershell
az network application-gateway show-backend-health --resource-group '<lab-rg>' --name '<gateway-name>' --output json
```

Backend health is one signal. Also test the intended public hostname/client TLS path and correlate WAF logs where applicable. Keep public identifiers and raw logs out of shared documentation.

Traffic Manager needs special care: a default `trafficmanager.net` name is not proof of a valid application certificate. Follow the example's DNS-selection test and request the selected App Service hostname, or design an owned custom domain and matching certificates for every backend.
