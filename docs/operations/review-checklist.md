# Contributor review checklist

Review a concrete configuration and its teaching claims together.

1. Confirm the default remains a small network-only shape and every paid service is explicit.
2. Compare profile flags, dependency validations, module calls and outputs; do not rely on prose alone.
3. Check CIDR derivation, nonoverlap, special subnet names/delegation and administration sources.
4. Draw forward and return paths. Keep Route Server control traffic separate from application packets.
5. Verify private DNS, forwarding target, endpoint approval and service identity as separate layers.
6. Inspect Firewall/WAF scopes and egress dependencies without broad troubleshooting exceptions.
7. Review state/moved-block compatibility and exact cleanup ownership, including shared-service children.
8. Map new material to the dated objective matrix using Terraform-backed, reference configuration or design exercise.
9. Keep synthetic observations labelled and all unperformed Azure tests NOT RUN.
10. Update Mermaid source and matching SVG together; inspect readability and accessible title/description.
11. Run local checks and review generated references through [contributor instructions](../../CONTRIBUTING.md).
12. Confirm no credentials, local tfvars, state, saved plans, raw logs or unrequested automation definitions are tracked.

No step requires a cloud deployment. [Validation status](../validation-status.md) records actual checks.
