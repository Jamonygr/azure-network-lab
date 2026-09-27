# Local checks and future evidence

**Azure deployment, resource queries, guest execution and traffic validation: NOT RUN.** Local checks establish syntax, schema, intended relationships and documentation quality. They cannot establish Azure acceptance or connectivity.

## Supported local entry point

Run from the repository with the required local tools:

```powershell
pwsh ./scripts/Test-Offline.ps1
```

The runner's isolated source-copy boundary prevents ignored local tfvars/state from becoming test inputs. It uses the supplied mocked tests rather than a normal cloud-aware plan. Inspect PASS/FAIL/SKIP results; missing optional tools are not proof that their checks passed. Exact results are recorded in [validation status](../../docs/validation-status.md).

The reference generator is a separate local authoring command:

```powershell
pwsh ./scripts/Update-TerraformReference.ps1
```

Review generated Markdown changes. Do not replace offline tests with `az login`, `terraform plan`, refresh, import, apply or destroy. Backend-disabled initialization alone does not make a subsequent ordinary plan cloud-free.

## Low-level checks in an isolated source-only copy

If diagnosing the runner, use a directory containing only reviewed tracked source/templates/tests/lockfiles, with no live tfvars, state, backend credentials, environment credentials or production backend configuration. In that isolated copy:

```powershell
terraform fmt -check -recursive
terraform init -backend=false -input=false -lockfile=readonly
terraform validate
# Run only the supplied tests that use mock providers:
terraform test
```

Provider downloads can require Internet access. Provider initialization and mock acceptance are distinct from Azure API calls. Do not run arbitrary test files without reviewing whether they use mocked providers.

## Evidence contract for future operators

For each later live check record:

| Field | Required content |
|---|---|
| Scope | Root/profile, commit, redacted lab identifier |
| Time | UTC timestamp and relevant log window |
| Client | Source network/host and resolver |
| Identity | Intended authorized principal, redacted |
| Request | Destination name, resolved IP, protocol/port and expected result |
| Path | Selected forward and return route |
| Observation | Actual result, log/action or explicit NOT RUN |
| Boundary | What the observation does not prove |

A successful deployment is configuration evidence. A DNS answer is name-resolution evidence. A real authorized request plus return path and correlated controls is stronger traffic evidence. Preserve those distinctions.

Use [component checks](component-checks.md), [routes](route-validation.md), [DNS](dns-validation.md), [the matrix](test-matrix.md) and [troubleshooting](troubleshooting.md). All commands there are future references, not results of this update.
