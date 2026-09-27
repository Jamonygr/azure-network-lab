# Minimal address and security footprint

**Mode:** configuration exercise. **Azure deployment and live verification: NOT RUN.**

## Objectives and configuration

Address spaces, service subnets, NSGs and cost boundaries.

Use [profiles/minimal.tfvars.example](../../profiles/minimal.tfvars.example) with the main root. Three VNets and their service-subnet reservations remain. Two directed peerings connect Spoke1 and Spoke2; the branch stays isolated. No optional paid service is selected. No VM password is needed.

## Step 1 — Review without Azure

From the repository root:

```powershell
Get-Content profiles/minimal.tfvars.example
Get-Content locals.tf
```

Record selected services, external inputs, state owner and predicted packet path. Compare [architecture](../architecture/overview.md) and [objective mapping](../reference/az-700-alignment.md).

## Step 2 — Document a future operation

The [operator checklist](../../docs/operations/deployment-checklist.md) supplies the full input/state/cost sequence. This is a **future authorized operator reference**, not an offline check:

```powershell
$profile = 'minimal'
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

No plan or apply was run. Resolve actual tenant, subscription, permission, quota, region and dependencies before future use.

## Step 3 — Predict evidence

Only after a separately authorized deployment, these outputs can feed the [diagnostic guide](../testing/lab-testing-guide.md):

```powershell
terraform output -json subnet_address_plan
terraform output -json enabled_services
```

Expect three nonoverlapping allocations, bidirectional spoke peering and no optional paid services. A subnet's presence does not enable its named service. Record observations separately from predictions. If a client/service is absent, use **NOT RUN**, not PASS.

## Troubleshooting

Correct overlapping parent CIDRs; do not bypass validation. No Internet egress service or branch transit is promised. See [the symptom table](../testing/troubleshooting.md). Change one variable at a time.

## Cost and cleanup

Base networking only; optional services change cost. Use [the cost worksheet](../reference/cost-model.md). Future cleanup must use the same root, state, context and profile as creation. Review the [destroy procedure](../../docs/operations/deployment-checklist.md#future-cleanup) and shared-resource ownership. Nothing was deployed by this update.

## Completion artifact

Submit an annotated input file, forward/return path prediction, blank evidence record with expected results, and cleanup ownership list. Never publish state, plans or secrets.

[Scenario index](README.md) · [Book](../book.md)
