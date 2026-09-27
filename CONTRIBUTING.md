# Contributing

Changes should improve configuration correctness, teaching clarity or operational boundaries. This repository update follows a **local-only validation rule**: never deploy or execute Azure labs as a validation shortcut.

## Local work

Use Terraform 1.16.4 and the pinned AzureRM 4.57.0 lockfiles. PowerShell 7+ is required for local tooling; 7.4+ is recommended. Read the chosen profile/example and do not inspect or copy another operator's private tfvars/state.

```powershell
pwsh ./scripts/Test-Offline.ps1
pwsh ./scripts/Update-TerraformReference.ps1
```

The test runner works with source-only copies and supplied mock definitions. Missing tools must be reported as SKIP or failure according to the runner, never silently claimed as a pass. Reference generation updates Markdown; review the result. Exact local results belong in [validation status](docs/validation-status.md).

Do not run cloud-aware Terraform plans, resource queries, imports, applies, destroys, guest commands or traffic tests for a contribution unless the owner explicitly changes the no-execution scope.

## Configuration changes

Keep root orchestration, derived maps and module interfaces clear. Preserve existing addresses through moved blocks where appropriate. Validate unsupported flag combinations and retain a minimal default. Independent examples need their own resource ownership, opt-in costs, exact input/output contract, mock tests and cleanup instructions.

## Documentation changes

Use the [five-domain course](wiki/book.md) and [objective map](wiki/reference/az-700-alignment.md). Describe only the implemented slice of a service; label external-client/provider dependencies. Do not copy Microsoft objective prose wholesale or imply every current topic was newly added in July 2026.

Update `.mmd` and matching `.svg` files together. Every diagram needs a meaningful `accTitle`, `accDescr`, readable labels and a caption explaining the boundary. Render locally with Mermaid CLI 12, review images, and keep SVGs free of embedded font bloat. Do not present an idealized topology as the actual default.

## Review

Use [the review checklist](docs/operations/review-checklist.md). Provide the problem, final behavior, affected profiles, local checks and remaining NOT RUN items. Keep secrets, state, plans and live resource identifiers out of examples. No publishing or commit is part of a validation command.
