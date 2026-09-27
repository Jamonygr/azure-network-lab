# Command boundaries

## Local source checks

```powershell
pwsh ./scripts/Test-Offline.ps1
pwsh ./scripts/Update-TerraformReference.ps1
```

The reference generator changes generated Markdown; review the diff. Read runner output for PASS, FAIL or SKIP rather than assuming every optional tool exists.

Direct Terraform source checks use `fmt -check`, `init -backend=false` and `validate`. Initialization can download providers. Only supplied mocked tests belong in offline runs; an ordinary plan can access Azure.

## Future operator references only

See the [full checklist](../../docs/operations/deployment-checklist.md) before these categories:

| Command | What it can do |
|---|---|
| `terraform plan` | Authenticate, refresh, query data sources and write sensitive plan data |
| `terraform show` | Display saved plan/state information, possibly sensitive |
| `terraform apply` | Create/change/delete real Azure resources |
| `terraform plan -destroy` | Read Azure and calculate removals |
| `terraform output` | Read local/backend state, not independently test traffic |
| `az network ... show/list` | Query actual subscription resources when authenticated |
| `Resolve-DnsName`, `Test-NetConnection` | Generate real network queries/traffic |

No cloud command above was executed for this update. Never paste placeholders blindly into an authenticated terminal. Use [evidence templates](../testing/lab-testing-guide.md).
