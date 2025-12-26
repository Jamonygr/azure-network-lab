# State and secrets

This lab uses local state by default. For shared or long-lived labs, move state to Azure Storage and treat credentials as secrets.

## Local state (default)

- State files are stored next to the repo.
- Keep them out of git using `.gitignore`.
- Use `terraform show` only on trusted machines.

## Remote state (recommended)

1. Create a storage account and container for `tfstate`.
2. Enable blob versioning and soft delete.
3. Configure a backend in Terraform or use `-backend-config`.

Example backend config:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstate<suffix>"
    container_name       = "tfstate"
    key                  = "az700-lab.tfstate"
  }
}
```

## Secret handling

- Do not commit `terraform.tfvars` if it contains passwords or keys.
- Use environment variables (`TF_VAR_admin_password`) in CI or shared environments.
- Rotate VPN keys after lab usage.

## Recommended hygiene

- Store admin credentials in a password manager or Key Vault.
- Use a dedicated subscription for labs to limit blast radius.
