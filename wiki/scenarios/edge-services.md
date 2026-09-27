# Regional application delivery

**Mode:** configuration exercise. **Azure deployment and live verification: NOT RUN.**

## Objectives and configuration

Internal LB, WAF_v2, web backends, probes and TLS.

Use [profiles/application-delivery.tfvars.example](../../profiles/application-delivery.tfvars.example) with the main root. Two Spoke1 Windows web VMs, NAT, Standard internal LB and App Gateway are selected. Root wiring supplies backend IPs; guest IIS acceptance is unverified. Optional frontend HTTPS needs an existing certificate, identity and hostname.

## Step 1 — Review without Azure

From the repository root:

```powershell
Get-Content profiles/application-delivery.tfvars.example
Get-Content modules/application-gateway/main.tf
```

Record selected services, external inputs, state owner and predicted packet path. Compare [architecture](../architecture/overview.md) and [objective mapping](../reference/az-700-alignment.md).

## Step 2 — Document a future operation

The [operator checklist](../../docs/operations/deployment-checklist.md) supplies the full input/state/cost sequence. This is a **future authorized operator reference**, not an offline check:

```powershell
$profile = 'application-delivery'
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

No plan or apply was run. Resolve actual tenant, subscription, permission, quota, region and dependencies before future use.

## Step 3 — Predict evidence

Only after a separately authorized deployment, these outputs can feed the [diagnostic guide](../testing/lab-testing-guide.md):

```powershell
terraform output -raw application_gateway_public_ip
terraform output -raw load_balancer_frontend_ip
terraform output -raw vm_spoke1_1_private_ip
```

Require healthy backends plus an application response. Inspect TLS frontend and backend independently. An internal LB requires a private client. Record observations separately from predictions. If a client/service is absent, use **NOT RUN**, not PASS.

## Troubleshooting

A 502 can indicate probe path, host header, route, guest service, NSG or TLS problems. Do not relax WAF to hide a backend fault. See [the symptom table](../testing/troubleshooting.md). Change one variable at a time.

## Cost and cleanup

App Gateway, two VMs/disks, NAT and public IPs dominate cost. Use [the cost worksheet](../reference/cost-model.md). Future cleanup must use the same root, state, context and profile as creation. Review the [destroy procedure](../../docs/operations/deployment-checklist.md#future-cleanup) and shared-resource ownership. Nothing was deployed by this update.

## Completion artifact

Submit an annotated input file, forward/return path prediction, blank evidence record with expected results, and cleanup ownership list. Never publish state, plans or secrets.

[Scenario index](README.md) · [Book](../book.md)
