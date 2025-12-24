# Modules overview

All modules are thin, single-responsibility building blocks. Each module accepts the shared `ctx` object and relies on the root module for provider configuration.

## Conventions
- `ctx.project` drives naming; `ctx.location` sets region; `ctx.tags` apply tags.
- Optional resources are enabled by the root module using `count` or `for_each`.
- Modules avoid embedded providers; root `providers.tf` owns provider configuration.

## Module categories

| Category | Modules |
|----------|---------|
| Networking | vwan, vhub, vhub-connection, vhub-firewall, vhub-vpn-gateway, vnet, nsg, vnet-peering, route-server, vpn-gateway, vpn-site, vpn-connection, local-network-gateway, nat-gateway, load-balancer, application-gateway, bastion, dns-private-resolver, private-dns-zone |
| Compute | vm-windows, vm-windows-nva |
| Security | tags, vhub-firewall, nsg |
| Monitoring | log-analytics |
| PaaS | storage-account, private-endpoint |

For details, see the module-specific pages.
