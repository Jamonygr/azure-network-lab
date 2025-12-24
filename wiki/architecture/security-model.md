# Security model

The lab uses layered security: optional firewall at the hub, NSGs at the subnet level, and private access defaults for PaaS.

## Guardrails and defaults
- Required tags are enforced by the `tags` module.
- Storage account public access is disabled by default.
- Admin passwords require a minimum length of 12 characters.

## Network Security Groups (NSGs)
- Baseline rules allow RDP, HTTP, HTTPS, and ICMP for lab testing.
- On-prem NSG adds a rule for RDP from the on-prem range.
- NSGs are attached to workload and NVA subnets.

## Secured hub
- When enabled, Azure Firewall is deployed in the vHub.
- Routing intent is configured to steer traffic through the firewall.

## Private access
- Private DNS zones handle private endpoint name resolution.
- Storage access is private by default using a private endpoint.

## NVA security
- NVA NICs have IP forwarding enabled.
- RRAS and BGP are configured via a VM extension script.

## Operational guidance
- Use Bastion for access when enabled.
- Rotate admin passwords and VPN shared keys if reused.
