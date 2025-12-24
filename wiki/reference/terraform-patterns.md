# Terraform patterns

This repo uses a consistent set of Terraform patterns for readability and safety.

## Shared ctx object
All modules accept `ctx` (project, location, tags) to keep inputs consistent.

## Data-driven maps
Resources are created via `for_each` over maps in `locals.tf`:
- VNets and subnets
- NSGs and rules
- VMs and NVAs
- vHub connections and BGP connections

## Optional resources
Optional modules use `count` (0 or 1) and filtered maps to avoid drift.

## Guardrails
- Variable validation for naming and location.
- Preconditions for critical defaults (example: storage public access off).

## State safety
`moved` blocks in `moved.tf` preserve state addresses after refactors.
