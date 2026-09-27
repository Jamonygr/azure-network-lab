# Future operator checklist

**Reference procedure only. No Azure login, plan, deployment, resource query or lab execution was performed for this update.** Complete local source review through [Test-Offline.ps1](../../scripts/Test-Offline.ps1); the commands below are deliberately live-capable.

## 1. Select scope and ownership

Choose one main-root profile or one independent example. Use a separate directory/state for concurrent scenarios. Identify the owner of every created and reused resource, including Network Watcher child objects. Read [cost planning](../../wiki/reference/cost-model.md) and [state guidance](../../wiki/reference/state-and-secrets.md).

Confirm the correct tenant/subscription, region/SKU availability, quota and permissions. Ordinary Contributor does not grant permission to assign RBAC roles; examples that create assignments require appropriate authorization at their actual scopes. No effective-permission or quota check is claimed by offline tests.

## 2. Prepare the main-root inputs

This step is for a future authorized operator in a selected root directory:

```powershell
Copy-Item -LiteralPath terraform.tfvars.example -Destination terraform.tfvars
New-Item -ItemType Directory -Path .local -Force | Out-Null
$profile = 'minimal'
```

Edit the local template's real subscription, project, region and tags. Never copy private values into the committed template. Profile files are `profiles/<name>.tfvars.example` and are passed explicitly; they do not isolate state.

If selected VMs or VPN require credentials, provide the respective `TF_VAR_admin_password` or `TF_VAR_vpn_shared_key` from an approved secret source. Do not hard-code them in a command transcript. Minimal needs neither. Record any existing certificate identity, DNS target or Network Watcher dependency.

The final deploy object replaces the earlier one; files do not recursively merge it. A profile switch against existing state can remove resources.

## 3. Confirm the account and inspect a saved plan

**Live-capable future commands, NOT RUN:**

```powershell
az account show --query '{subscription:id,tenant:tenantId,name:name}' --output table
terraform version
terraform init -input=false -lockfile=readonly
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

Confirm exact root/state/profile/subscription, required versions, expected resource changes, cost-bearing services, address ranges, public entries, service dependencies and all replacements/removals. Preserve prior state before a migration. A saved plan may contain secrets; keep it ignored and protected.

If any input/source changes after review, create and inspect a new plan. A separately authorized operator can then apply the exact reviewed file:

```powershell
terraform apply ".local/$profile.tfplan"
```

This documentation is not an instruction for the repository maintainer to deploy anything.

## 4. Collect evidence

Use the selected [scenario](../../wiki/scenarios/README.md) and [evidence contract](../../wiki/testing/lab-testing-guide.md). Separate configuration, DNS, route, policy, identity and application outcomes. Unsupported clients/dependencies remain NOT RUN. Never mark a mocked result as Azure evidence.

## Future cleanup

In the same root/state, keep the exact inputs used for creation. First inventory externally shared resources and lab-owned children. Then a future authorized operator can review removals:

```powershell
terraform plan -destroy -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/destroy-$profile.tfplan"
terraform show ".local/destroy-$profile.tfplan"
# Only after checking every removal and ownership:
terraform apply ".local/destroy-$profile.tfplan"
terraform state list
```

An empty state is necessary but not enough to prove no residual charges. Verify owned resource groups and recorded child IDs. Flow logs/Connection Monitor can be under a shared Network Watcher group; delete only the lab-owned children through this state, leaving the shared watcher intact. Independent examples require cleanup in their own roots; the endpoint-policy example owns two groups.

Do not use broad resource-group deletion to compensate for lost state. Review public IPs, disks, endpoints, logs/retention and soft-deleted service artifacts as applicable. Preserve protected evidence/backup according to the owner's retention decision. There are no resources from this update to clean up.
