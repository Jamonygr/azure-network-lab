# Route Server: routes are not packets

**Mode:** configuration exercise. **Azure deployment and live verification: NOT RUN.**

## Objectives and configuration

Route Server, BGP, NVA forwarding and topology exclusions.

Use [profiles/route-server.tfvars.example](../../profiles/route-server.tfvars.example) with the main root. The profile selects Route Server, two RRAS NVAs and explicit NAT. Workload VMs are off. The synthetic 10.100.0.0/16 route has no deployed destination; the two NVAs have no implied interconnecting tunnel.

## Step 1 — Review without Azure

From the repository root:

```powershell
Get-Content profiles/route-server.tfvars.example
Get-Content modules/route-server/main.tf
```

Record selected services, external inputs, state owner and predicted packet path. Compare [architecture](../architecture/overview.md) and [objective mapping](../reference/az-700-alignment.md).

## Step 2 — Document a future operation

The [operator checklist](../../docs/operations/deployment-checklist.md) supplies the full input/state/cost sequence. This is a **future authorized operator reference**, not an offline check:

```powershell
$profile = 'route-server'
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

No plan or apply was run. Resolve actual tenant, subscription, permission, quota, region and dependencies before future use.

## Step 3 — Predict evidence

Only after a separately authorized deployment, these outputs can feed the [diagnostic guide](../testing/lab-testing-guide.md):

```powershell
terraform output -json route_server_virtual_router_ips
terraform output -raw route_server_virtual_router_asn
terraform output -raw vm_spoke1_nva_private_ip
```

Separate guest extension state, both BGP sessions, received routes, effective route and real destination traffic. Spoke1 has no vHub attachment. Record observations separately from predictions. If a client/service is absent, use **NOT RUN**, not PASS.

## Troubleshooting

A failed ping to a synthetic prefix does not diagnose BGP. Inspect guest configuration, forwarding, peer reachability and ASN. See [the symptom table](../testing/troubleshooting.md). Change one variable at a time.

## Cost and cleanup

Route Server, two NVAs, disks and NAT services incur charges. Use [the cost worksheet](../reference/cost-model.md). Future cleanup must use the same root, state, context and profile as creation. Review the [destroy procedure](../../docs/operations/deployment-checklist.md#future-cleanup) and shared-resource ownership. Nothing was deployed by this update.

## Completion artifact

Submit an annotated input file, forward/return path prediction, blank evidence record with expected results, and cleanup ownership list. Never publish state, plans or secrets.

[Scenario index](README.md) · [Book](../book.md)
