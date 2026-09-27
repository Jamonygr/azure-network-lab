# Security and operational boundaries

This repository contains real infrastructure definitions and future operator procedures. They can create billable resources if a reader executes them. **No Azure lab was deployed or executed for this update.**

## Reporting

Do not include credentials, private keys, PSKs, raw Terraform state/plans or unredacted environment output in public issues. Describe the affected configuration and an anonymized reproduction. Use a private reporting channel where available for a vulnerability with sensitive details.

## Secrets and identity

Real tfvars, state, plans and evidence remain ignored and protected. Sensitive Terraform variables are still stored in state. Use an approved secret source for VM passwords/PSKs and protect process environment/transcripts. Independent Linux examples accept public SSH keys only; private keys stay outside the repository.

Choose the correct tenant/subscription and least permissions for each operation. Resource management and data-plane access are different roles. Some examples need role-assignment permission; do not assume Contributor supplies it.

## Network controls

Review management sources, explicit egress, route symmetry, private endpoint approval, DNS and service authorization independently. The root denies implicit outbound and offers explicit NAT/Firewall paths. A permitted name or route is not proof of a successful application request.

Monitoring storage deliberately has service-specific network/write settings and must not be confused with private-only sample storage. WAF defaults and sample HTTP are teaching choices; sample pages contain no secrets.

No DDoS attack generation, unowned device interaction, tenant consent change or external appliance activation is part of the exercises. Such dependencies are labelled.

## Validation and cleanup

Local schema/mocked tests do not establish deployment permission, SKU availability, guest execution or traffic success. Keep Azure outcomes NOT RUN until separately authorized and measured. Preserve the distinction between synthetic tables and actual logs.

Cleanup uses the exact owning root/state. A shared Network Watcher stays; lab-owned child resources are tracked separately. Do not delete broad shared groups to hide incomplete teardown. [State and secrets](wiki/reference/state-and-secrets.md) · [Future operator checklist](docs/operations/deployment-checklist.md)
