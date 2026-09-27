# Virtual WAN connection ownership

**Mode:** configuration exercise. **Azure deployment and live verification: NOT RUN.**

## Objectives and configuration

Hub connections, propagation and service chaining.

Use [profiles/vwan-secured.tfvars.example](../../profiles/vwan-secured.tfvars.example) with the main root. This profile includes Firewall. Inspect vWAN connections and routing intent together; it is not a bare uninspected hub.

## Step 1 — Review without Azure

From the repository root:

```powershell
Get-Content profiles/vwan-secured.tfvars.example
Get-Content modules/vhub-connection/main.tf
```

Record selected services, external inputs, state owner and predicted packet path. Compare [architecture](../architecture/overview.md) and [objective mapping](../reference/az-700-alignment.md).

## Step 2 — Document a future operation

The [operator checklist](../../docs/operations/deployment-checklist.md) supplies the full input/state/cost sequence. This is a **future authorized operator reference**, not an offline check:

```powershell
$profile = 'vwan-secured'
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

No plan or apply was run. Resolve actual tenant, subscription, permission, quota, region and dependencies before future use.

## Step 3 — Predict evidence

Only after a separately authorized deployment, these outputs can feed the [diagnostic guide](../testing/lab-testing-guide.md):

```powershell
terraform output -json connected_hub_vnets
terraform output -raw vhub_id
```

Spoke1 and Spoke2 are eligible hub connections while Route Server is disabled. Record selected routes in both directions. Record observations separately from predictions. If a client/service is absent, use **NOT RUN**, not PASS.

## Troubleshooting

A connection existing does not prove the selected path. Review propagation before changing policy. See [the symptom table](../testing/troubleshooting.md). Change one variable at a time.

## Cost and cleanup

vHub, Firewall, public IP and processing bill independently of guest VMs. Use [the cost worksheet](../reference/cost-model.md). Future cleanup must use the same root, state, context and profile as creation. Review the [destroy procedure](../../docs/operations/deployment-checklist.md#future-cleanup) and shared-resource ownership. Nothing was deployed by this update.

## Completion artifact

Submit an annotated input file, forward/return path prediction, blank evidence record with expected results, and cleanup ownership list. Never publish state, plans or secrets.

[Scenario index](README.md) · [Book](../book.md)
