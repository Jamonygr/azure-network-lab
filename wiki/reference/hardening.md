# Hardening checklist

These steps tighten the lab configuration without changing its core architecture.

## Identity and access
- Use unique, strong admin passwords.
- Rotate VPN shared keys regularly.
- Add additional required tags like `CostCenter` or `Owner`.

## Network security
- Restrict NSG rules to known admin IPs if testing remotely.
- Disable ICMP and HTTP rules when not needed.
- Enable Azure Firewall for all hub connections.

## Private access
- Keep storage public access disabled.
- Prefer private endpoints and private DNS zones for PaaS.

## Operations
- Store secrets in a vault or environment variables, not in git.
- Use remote state with blob versioning for rollback.
- Export logs to Log Analytics and review firewall diagnostics.
