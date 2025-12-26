# AZ-700 alignment

This page maps the lab to the AZ-700 skills measured. The official outline can change, so use this as a guide and check the Microsoft exam page for updates.

## Design and implement core networking infrastructure

- vWAN + vHub: `modules/vwan`, `modules/vhub`, `modules/vhub-connection`.
- Spokes and peering: `modules/vnet`, `modules/vnet-peering`, `modules/nsg`.
- DNS and private access: `modules/private-dns-zone`, `modules/dns-private-resolver`, `modules/private-endpoint`, `modules/storage-account`.
- Edge services: `modules/load-balancer`, `modules/nat-gateway`, `modules/application-gateway`, `modules/bastion`.

Key docs:

- `architecture/overview.md`
- `architecture/vwan-and-vhub.md`
- `architecture/spokes-and-peerings.md`
- `architecture/dns-and-private-link.md`
- `scenarios/vwan-basics.md`
- `scenarios/edge-services.md`

## Design and implement routing

- vHub routing intent with firewall inspection: `modules/vhub-firewall`.
- BGP via Route Server and RRAS NVA: `modules/route-server`, `modules/vm-windows-nva`.
- BGP via VPN gateways: `modules/vhub-vpn-gateway`, `modules/vpn-gateway`, `modules/vpn-site`, `modules/vpn-connection`.

Key docs:

- `architecture/routing-and-bgp.md`
- `architecture/traffic-flows.md`
- `architecture/route-server-and-nva.md`
- `scenarios/route-server-bgp.md`
- `scenarios/vpn-bgp.md`
- `testing/route-validation.md`

## Secure and monitor networks

- Hub security inspection: firewall policy + routing intent.
- NSGs for subnet isolation and traffic control.
- Private access posture: storage public access disabled; private endpoint + private DNS.
- Monitoring baseline: Log Analytics workspace (no diagnostics wired by default).

Key docs:

- `architecture/firewall-and-routing-intent.md`
- `architecture/security-model.md`
- `reference/hardening.md`
- `modules/security.md`
- `modules/monitoring.md`
- `testing/component-checks.md`

## Design and implement hybrid networking

- vHub VPN gateway + on-prem VPN gateway with BGP.
- On-prem simulation VNet and RRAS NVA.

Key docs:

- `architecture/vpn-and-hybrid.md`
- `scenarios/vpn-bgp.md`
- `testing/route-validation.md`

## Suggested study path

1. `scenarios/vwan-basics.md`
2. `scenarios/secured-hub-firewall.md`
3. `scenarios/route-server-bgp.md`
4. `scenarios/vpn-bgp.md`
5. `scenarios/private-endpoints-dns.md`
6. `scenarios/edge-services.md`
7. `testing/test-matrix.md`

## Quick toggle map

| Skill area | Key deploy flags |
|------------|------------------|
| Core networking | `deploy.vwan`, `deploy.spoke1_vms`, `deploy.spoke2_vms`, `deploy.private_dns_zones`, `deploy.dns_resolver` |
| Routing | `deploy.vhub_firewall`, `deploy.route_server`, `deploy.vpn` |
| Secure and monitor | `deploy.vhub_firewall`, `deploy.private_endpoint`, `deploy.private_dns_zones` |
| Hybrid | `deploy.vpn`, `deploy.onprem_vms`, `deploy.nvas` |
