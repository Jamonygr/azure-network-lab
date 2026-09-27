# Private Blob access and DNS

**Mode:** configuration exercise. **Azure deployment and live verification: NOT RUN.**

## Objectives and configuration

Private endpoints, resolver, private zones and access layers.

Use [profiles/private-dns.tfvars.example](../../profiles/private-dns.tfvars.example) with the main root. No client VM or real branch DNS is created. dns_forwarding_rules defaults empty; an outbound endpoint/ruleset alone does not forward an external namespace.

## Step 1 — Review without Azure

From the repository root:

```powershell
Get-Content profiles/private-dns.tfvars.example
Get-Content modules/dns-private-resolver/main.tf
```

Record selected services, external inputs, state owner and predicted packet path. Compare [architecture](../architecture/overview.md) and [objective mapping](../reference/az-700-alignment.md).

## Step 2 — Document a future operation

The [operator checklist](../../docs/operations/deployment-checklist.md) supplies the full input/state/cost sequence. This is a **future authorized operator reference**, not an offline check:

```powershell
$profile = 'private-dns'
terraform plan -var-file=terraform.tfvars -var-file="profiles/$profile.tfvars.example" -out=".local/$profile.tfplan"
terraform show ".local/$profile.tfplan"
```

No plan or apply was run. Resolve actual tenant, subscription, permission, quota, region and dependencies before future use.

## Step 3 — Predict evidence

Only after a separately authorized deployment, these outputs can feed the [diagnostic guide](../testing/lab-testing-guide.md):

```powershell
terraform output -raw storage_account_name
terraform output -raw private_endpoint_storage_ip
terraform output -raw dns_resolver_inbound_ip
terraform output -raw dns_forwarding_ruleset_id
```

An authorized private client should resolve the normal Blob hostname privately and complete an allowed data operation. Compare with an authorized public client when proving public-network denial. Record observations separately from predictions. If a client/service is absent, use **NOT RUN**, not PASS.

## Troubleshooting

Check resolver, CNAME/A record, link, forwarding target, route, endpoint approval and RBAC separately. Avoid forwarding loops. See [the symptom table](../testing/troubleshooting.md). Change one variable at a time.

## Cost and cleanup

Resolver endpoints, endpoint hours, storage and DNS requests can bill without a VM. Use [the cost worksheet](../reference/cost-model.md). Future cleanup must use the same root, state, context and profile as creation. Review the [destroy procedure](../../docs/operations/deployment-checklist.md#future-cleanup) and shared-resource ownership. Nothing was deployed by this update.

## Completion artifact

Submit an annotated input file, forward/return path prediction, blank evidence record with expected results, and cleanup ownership list. Never publish state, plans or secrets.

[Scenario index](README.md) · [Book](../book.md)
