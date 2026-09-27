# Hybrid VPN: Azure-hosted branch

**Mode:** configuration exercise. **Azure deployment and live verification: NOT RUN.**

## Objectives and configuration

Gateways, site, connections, BGP and external-device boundaries.

Use [profiles/hybrid-vpn.tfvars.example](../../profiles/hybrid-vpn.tfvars.example) with the main root. Compare hub/branch addresses, ASNs, peer IPs and prefixes. Supply the PSK privately. No client VMs are enabled by this profile.

## Step 1 — Review without Azure

From the repository root:

```powershell
Get-Content profiles/hybrid-vpn.tfvars.example
Get-Content modules/vpn-site/main.tf
```

Record selected services, external inputs, state owner and predicted packet path. Compare [architecture](../architecture/overview.md) and [objective mapping](../reference/az-700-alignment.md).

## Step 2 — Document a future operation

The [operator checklist](../../docs/operations/deployment-checklist.md) supplies the full input/state/cost sequence. This is a **future authorized operator reference**, not an offline check:

```powershell
$profile = 'hybrid-vpn'
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

No plan or apply was run. Resolve actual tenant, subscription, permission, quota, region and dependencies before future use.

## Step 3 — Predict evidence

Only after a separately authorized deployment, these outputs can feed the [diagnostic guide](../testing/lab-testing-guide.md):

```powershell
terraform output -raw onprem_vpn_gateway_public_ip
terraform output -raw vhub_id
```

Future evidence needs tunnel state, learned routes and a real authorized host request/response. This Azure-hosted branch does not test physical-device compatibility. Record observations separately from predictions. If a client/service is absent, use **NOT RUN**, not PASS.

## Troubleshooting

Separate PSK/policy, BGP peer, route advertisement and return-route faults. A green tunnel can carry no useful traffic. See [the symptom table](../testing/troubleshooting.md). Change one variable at a time.

## Cost and cleanup

Two gateway types, vHub and transfer continue billing while idle. Use [the cost worksheet](../reference/cost-model.md). Future cleanup must use the same root, state, context and profile as creation. Review the [destroy procedure](../../docs/operations/deployment-checklist.md#future-cleanup) and shared-resource ownership. Nothing was deployed by this update.

## Completion artifact

Submit an annotated input file, forward/return path prediction, blank evidence record with expected results, and cleanup ownership list. Never publish state, plans or secrets.

[Scenario index](README.md) · [Book](../book.md)
