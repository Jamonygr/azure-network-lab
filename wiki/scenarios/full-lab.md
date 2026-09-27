# Legacy combined topology review

**Mode:** configuration exercise. **Azure deployment and live verification: NOT RUN.**

## Objectives and configuration

Dependency review, migration, exclusions and cumulative cost.

Use [profiles/legacy-combined.tfvars.example](../../profiles/legacy-combined.tfvars.example) with the main root. This explicit profile preserves the earlier broad teaching footprint. Route Server excludes Spoke1 from vHub; the full graph is not one centrally inspected topology.

## Step 1 — Review without Azure

From the repository root:

```powershell
Get-Content profiles/legacy-combined.tfvars.example
Get-Content moved.tf
```

Record selected services, external inputs, state owner and predicted packet path. Compare [architecture](../architecture/overview.md) and [objective mapping](../reference/az-700-alignment.md).

## Step 2 — Document a future operation

The [operator checklist](../../docs/operations/deployment-checklist.md) supplies the full input/state/cost sequence. This is a **future authorized operator reference**, not an offline check:

```powershell
$profile = 'legacy-combined'
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

No plan or apply was run. Resolve actual tenant, subscription, permission, quota, region and dependencies before future use.

## Step 3 — Predict evidence

Only after a separately authorized deployment, these outputs can feed the [diagnostic guide](../testing/lab-testing-guide.md):

```powershell
terraform output -json enabled_services
terraform output -json connected_hub_vnets
```

Submit a dependency matrix identifying hub connections, peers, synthetic routes and external prerequisites. Existing-state migration needs separate review. Record observations separately from predictions. If a client/service is absent, use **NOT RUN**, not PASS.

## Troubleshooting

Switching to minimal can remove optional services. Preserve state and inspect moved blocks and all removals. See [the symptom table](../testing/troubleshooting.md). Change one variable at a time.

## Cost and cleanup

Multiple gateways, Firewall, resolver, Route Server, compute and delivery services can be expensive. Use [the cost worksheet](../reference/cost-model.md). Future cleanup must use the same root, state, context and profile as creation. Review the [destroy procedure](../../docs/operations/deployment-checklist.md#future-cleanup) and shared-resource ownership. Nothing was deployed by this update.

## Completion artifact

Submit an annotated input file, forward/return path prediction, blank evidence record with expected results, and cleanup ownership list. Never publish state, plans or secrets.

[Scenario index](README.md) · [Book](../book.md)
