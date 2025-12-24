# State and secrets

This lab uses local state by default. For shared or long-lived labs, consider remote state in Azure Storage.

## Local state
- State files are stored alongside the repo.
- Keep them out of git; use `.gitignore` to avoid accidental commits.

## Remote state (recommended)
- Create a storage account and container for `tfstate`.
- Configure a backend file or `terraform init -backend-config`.
- Enable blob versioning and soft delete.

## Secrets handling
- Do not commit `terraform.tfvars` if it contains passwords or keys.
- Use environment variables or a secure secrets store.
- Rotate shared keys after lab usage.
