# Seven independent example roots

Each example owns separate Terraform state and resources. **No example was deployed or executed.** Follow its README's exact input and future-operation sequence. Common context is `lab_id`, `subscription_id`, `tenant_id`, `location` and explicit `enable_paid_features`; main-root `ctx`/`deploy` profiles do not apply here.

## AVNM

[Configuration](../../examples/avnm/README.md). Inspect static membership, connectivity, security admin rules, routing and configuration deployment. Subscription scope is not membership of every VNet. Predict an administration-rule/NSG interaction and compare it with the configured topology.

## Front Door private origin

[Configuration](../../examples/front-door-private-origin/README.md). The example owns App Service and Premium/WAF resources. Origin Private Link requires approval. Explain frontend TLS, origin hostname/certificate checks, probes, cache and rules. Frontend access remains public.

## Traffic Manager

[Configuration](../../examples/traffic-manager/README.md). Compare `routing_method` values Priority, Weighted, Geographic and Performance. Inspect `secondary_location`, `endpoint_weights` and `geographic_mappings`. Draw the DNS answer separately from the application's direct connection and account for cached answers. The default trafficmanager.net name does not provide a valid application certificate; test the selected App Service hostname or design an owned custom domain with matching backend certificate bindings.

## Private Link service

[Configuration](../../examples/private-link-service/README.md). Inspect producer LB/backend, consumer endpoint/VM and private DNS. Supply an RSA public key through `ssh_public_key`; no private key belongs in Terraform inputs. Explain connection approval and producer/consumer boundaries.

## Service endpoint policy

[Configuration](../../examples/service-endpoint-policy/README.md). Two storage destinations have comparable client read authorization; the policy permits only the dedicated allowed-account resource group. The example owns that second resource group as well as its main group. Separate network-denial evidence from RBAC denial.

## Point-to-site VPN

[Configuration](../../examples/point-to-site-vpn/README.md). Review `vpn_aad_audience`, `vpn_aad_tenant_url`, `vpn_aad_issuer_url` and `vpn_client_address_pool`. Actual Entra consent/authorization, client import and login remain external. The example's SSH test host uses a public key.

## DDoS protection

[Configuration](../../examples/ddos-protection/README.md). Review the protection plan, associated VNet, public-IP/test-host relationship and monitoring. `alert_email` is optional. Produce a cost/metric decision record. **Do not generate attack traffic.**

## Evidence, troubleshooting, cost and cleanup

For every example: submit annotated inputs, diagram, prerequisites, predicted positive/negative results and an ownership list. The README supplies scenario-specific steps and future commands. Record live results as NOT RUN until actually measured; a mock assertion does not count as a private-path test.

Before blaming a network service, distinguish authentication, DNS, route, policy and application health. Every enabled paid service needs a cost review. Cleanup uses that example's directory and state, including its additional owned resource groups. Never delete shared external prerequisites merely because they appeared in the diagram. [Evidence contract](../testing/lab-testing-guide.md) · [Cost worksheet](../reference/cost-model.md)
