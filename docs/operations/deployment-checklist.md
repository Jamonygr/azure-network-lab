# Deployment Checklist

Use this checklist before and after every lab deployment. It is designed to keep cost, access, routing, and cleanup decisions visible.

## Before You Deploy

- Confirm the active Azure subscription and tenant.
- Review `terraform.tfvars` for location, tags, feature flags, and VM size.
- Set `deploy.vpn`, `deploy.application_gateway`, and `deploy.bastion` only when you need those scenarios.
- Confirm `admin_password` and `vpn_shared_key` are unique for this deployment.
- Estimate the monthly cost using `wiki/reference/cost-model.md`.

## Validate Locally

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=tfplan
```

Review the plan for:

- Expected resource count and names.
- Cost-bearing services that match the selected scenario.
- No accidental public access on storage.
- Expected vHub connection behavior when Route Server is enabled.

## After Apply

```bash
terraform output
az group show -g rg-<prefix> -o table
az network vwan show -g rg-<prefix> -n vwan-<prefix> -o table
```

Run the scenario-specific checks in `wiki/testing/lab-testing-guide.md`.

## Before Sharing Results

- Redact subscription IDs, public IPs, usernames, and generated resource IDs.
- Do not share Terraform state or plan files.
- Include the selected `deploy` profile when asking for help.

## Cleanup

```bash
terraform destroy
```

After destroy, confirm no orphaned public IPs, disks, gateways, or route tables remain in the resource group.
