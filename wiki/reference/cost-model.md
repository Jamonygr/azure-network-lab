# Cost model

Costs vary by region and time. Use the Azure Pricing Calculator for precise estimates, and treat this page as a guide to the biggest cost drivers.

## Major cost drivers

- Azure Firewall (vHub secured hub)
- vHub VPN Gateway
- Azure Route Server
- DNS Private Resolver
- Application Gateway (WAF v2)
- NAT Gateway
- Windows VMs

## Lower-cost profiles

- **Minimal**: vWAN + vHub + one spoke + VMs.
- **Standard**: add Route Server, DNS resolver, and private endpoint.
- **Full lab**: add firewall, VPN, App Gateway, Bastion.

## Cost control tips

- Disable high-cost services with `deploy` flags when not in use.
- Use small VM sizes for lab testing.
- Destroy the lab when idle (`terraform destroy`).
- Avoid running App Gateway or VPN gateways during basic testing.

## Related pages

- `reference/hardening.md`
- `testing/lab-testing-guide.md`
