# Security modules and scopes

NSGs attach to selected subnets. Additional administration sources come from `administration_source_cidrs`; the default is empty and a universal /0 management source is rejected. Bastion is opt-in.

The secured-hub Firewall has scoped private-network rules, explicit public HTTPS names, a Windows Update FQDN tag, Windows KMS destinations and optional monitor-service access. A public wildcard is not the default. Match this inventory to [the actual module](../../modules/vhub-firewall/main.tf) before any future use.

App Gateway policy mode defaults Prevention and can be selected explicitly. The public HTTP teaching listener handles no credentials; optional certificate/identity inputs enable the reviewed frontend TLS path. Backend TLS is a separate decision.

The independent AVNM and Front Door examples add different policy scopes. They are not silently applied to the root.

Private access also depends on identity and service authorization. A network allow does not grant a secret/blob read, and an RBAC role cannot establish a route. [Security model](../architecture/security-model.md) · [Hardening](../reference/hardening.md)
