# Terraform patterns

Root orchestration stays in `main.tf`; derived names, topology maps and filtered feature sets stay in `locals.tf`. Reusable service modules expose resources through clear input/output contracts. The [generated references](../../reference/root.md) supplement the teaching pages.

Feature flags determine resource presence. Validation/preconditions reject impossible or unsafe combinations rather than silently enabling services. A diagram must follow the selected flags and actual graph.

Use separate examples for distinct ownership and provider boundaries. Each example must explain paid opt-ins, external dependencies and cleanup. Avoid consuming another teaching root's local state.

Keep moved blocks when addressing existing-state compatibility. Do not rewrite resource addresses merely for cosmetic layout. Update tests and mapping when changing resource topology.

Reference HCL in [configuration patterns](configuration-patterns.md) is clearly separate from loaded root Terraform. It may require inputs/dependencies and must not be counted as a deployed root feature.

The local [offline runner](../../scripts/Test-Offline.ps1) and [reference generator](../../scripts/Update-TerraformReference.ps1) support contributor review. No automation definitions are required.
