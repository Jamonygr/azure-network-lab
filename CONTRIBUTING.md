# Contributing

Thanks for helping improve Azure Network Lab. This project is intentionally practical: changes should make the lab easier to deploy, easier to reason about, or safer to operate.

## Local Workflow

1. Create a branch from the latest default branch.
2. Make the smallest change that solves the problem.
3. Run the validation commands before opening a pull request.
4. Update docs when behavior, defaults, costs, or test steps change.

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

## Pull Request Checklist

- Terraform is formatted and validates locally.
- Feature toggles still support a low-cost deployment path.
- New resources include tags through the shared `ctx` object.
- Sensitive values stay in local `.tfvars` files, environment variables, or a secret store.
- README or wiki pages are updated when the user workflow changes.
- Cost, security, and cleanup implications are clear.

## Terraform Patterns

- Keep root orchestration in `main.tf` and derived maps in `locals.tf`.
- Prefer feature flags in the `deploy` object over commenting resources in and out.
- Reuse existing modules and naming conventions before adding new abstractions.
- Use variable validations or preconditions for guardrails that prevent expensive or unsafe mistakes.

## Documentation Standards

- Use concrete commands that can be copied into a terminal.
- Call out required Azure permissions, cost-bearing resources, and cleanup steps.
- Keep architecture pages descriptive and scenario pages action-oriented.
- Avoid committing generated state, plans, logs, or machine-specific files.
