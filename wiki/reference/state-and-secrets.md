# State, isolation and secrets

The main profiles share a root and do not create independent state. Use separate working directories/checkouts and distinct state for concurrent scenarios. Each independent example already has its own root; never copy another root's state into it.

Local state is operational data. It may contain VM passwords, PSKs and other sensitive values even when a variable is marked `sensitive`. Saved plans and crash/debug output can also contain secrets. Keep real tfvars, state, plans, evidence and credentials ignored and protected. Do not paste them into documentation.

For future collaboration, design a separate encrypted, locked and access-controlled backend; no shared backend is silently provisioned by this repository. Plan its bootstrap, identity, network reachability, backup and deletion order first.

## Future local backup procedure

Stop concurrent Terraform operations. Identify the exact root, state and context. In that root, make an ignored timestamped backup before a migration:

```powershell
$backup = Join-Path '.local/backups' ([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
Copy-Item -LiteralPath 'terraform.tfstate' -Destination (Join-Path $backup 'terraform.tfstate')
Get-Item -LiteralPath (Join-Path $backup 'terraform.tfstate') | Select-Object Name,Length,LastWriteTimeUtc
```

This applies only to a root actually using that local state filename. Never assume it backs up a remote backend. Protect/encrypt the backup and use approved external retention if required.

For recovery, verify root, subscription, resource ownership and state lineage before restoring an exact named backup. Do not blindly use state push or force-unlock. A backup is not permission to overwrite a newer state.

Existing root `moved.tf` addresses compatibility changes. Review migrations with the prior state preserved; cloud-aware migration plans were NOT RUN for this update.
