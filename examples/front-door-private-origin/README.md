# Front Door Premium, WAF, rules and a private App Service

Create a Premium Front Door profile, HTTPS route, WAF Prevention policy, rule set and bounded one-minute cache. An owned P0v3 Linux App Service runs a small Node 22 responder using its startup command. Its public network access is disabled. Front Door reaches it through App Service Private Link, validates its default-hostname TLS certificate, and forwards HTTPS with the matching Host header.

The rule adds `X-Lab-Rule: cache-demo`. Cache configuration ignores query strings because this synthetic response has no user-specific content; do not reuse that policy for personalized applications.

## Configuration and prerequisites

Only common inputs are required. Required providers: Microsoft.Network, Microsoft.Web, Microsoft.Cdn. Check Private Link origin region support and P0v3 quota. Outputs: `front_door_url`, `origin_url`, `origin_resource_id`, `private_link_approval_required` plus common lab/group outputs. No certificate file or custom domain is required.


## Independent state and local checks

This root owns its disposable resource groups and resources. It uses Terraform **1.16.4**, native AzureRM **4.57.0**, Azure CLI authentication, and ignored local state at `.local/terraform.tfstate`. It never imports or reads the repository root's real inputs/state. All taggable resources carry `lab_id` and `scenario`.

Copy `terraform.tfvars.example` to ignored `terraform.tfvars`, replace subscription/tenant placeholders and choose a unique `lab_id`. Review prices, provider registrations, region support, quotas, Azure Policy and role permissions before explicitly setting `enable_paid_features = true`. The default false blocks the resource-group precondition. It is a guard, not an Azure budget.

From this example directory, these checks use fully mocked plans:

~~~powershell
terraform init -backend=false -input=false -lockfile=readonly
terraform fmt -check
terraform validate
terraform test
~~~

Provider download access is needed unless a provider mirror is prepared. Mocked tests require no Azure credentials and prove configuration contracts only. They do not prove deployment or packet flow.

## Future manual deployment

These are future operator commands; this repository build did not run them:

~~~powershell
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit placeholders, review costs and set the paid-feature flag deliberately.
az login --tenant <your-tenant-guid>
az account set --subscription <your-subscription-guid>
az account show --query '{subscription:id,tenant:tenantId}' -o json
New-Item .local -ItemType Directory -Force | Out-Null
terraform init -reconfigure -input=false
terraform plan -out=.local/lab.tfplan
terraform show .local/lab.tfplan
# Verify every target belongs to this isolated example.
terraform apply .local/lab.tfplan
~~~

Azure provider registration is disabled in the configuration; register each required provider deliberately. Keep local variables, state and saved plans private. Providers can return sensitive attributes even when no password input exists. Regenerate the saved plan after changing inputs.

## Cleanup

Use only this example's local state. Keep the opt-in flag true while planning destruction; false does not destroy anything. Record any additional group listed below before applying the destroy plan.

~~~powershell
$lab = terraform output -raw lab_id
$group = terraform output -raw resource_group_name
if ((Read-Host "Type DESTROY $lab") -cne "DESTROY $lab") { throw "Cancelled" }
terraform plan -destroy -out=.local/destroy.tfplan
terraform show .local/destroy.tfplan
terraform apply .local/destroy.tfplan
az group exists --name $group
~~~

Require `false` for each owned group. Do not perform broad prefix-based group deletion or delete the state before checking cleanup. Retained service data and billing commitments are separate from active-resource deletion.

## Verification status

Formatting, pinned-provider schema checks and mocked Terraform tests are local acceptance. Cloud deployment and all live evidence below remain **NOT_RUN** until an operator runs the exercise. Save timestamps, exact resource IDs and observed results; do not present expected results as measured results.


## Expected live evidence

The managed Private Link connection needs explicit approval and may appear while Terraform is still waiting for origin provisioning. In the exact App Service's Networking > Private endpoint connections, compare target, request message and creation time with this Front Door origin. Approve only the matching request. If outputs already exist, list it with:

~~~powershell
$origin = terraform output -raw origin_resource_id
az network private-endpoint-connection list --id $origin -o table
~~~

If outputs do not yet exist, use the exact reviewed plan/portal ID. Never approve all pending connections, disable certificate checks, or open public origin access to bypass approval.

After approval and propagation:

~~~powershell
$edge = terraform output -raw front_door_url
$originUrl = terraform output -raw origin_url
curl.exe -i $edge
curl.exe -i ($edge + '?variant=second')
curl.exe -i -H "X-Lab-Block: true" $edge
curl.exe -i $originUrl
~~~

Expect the edge to return HTTP 200 with `private-origin-<lab_id>` and `X-Lab-Rule`. Record cache response headers across repeats; individual MISS results may occur during propagation or at a different edge. The deliberate WAF header should yield 403. The direct public origin should also yield 403. Retain approved connection status and healthy origin probes beside HTTP evidence. Never use TLS-bypass options.

## Troubleshooting

502/503 usually points to pending approval, wrong Host header, app startup or an unhealthy origin probe. Inspect App Service startup logs and Front Door origin health. Cache/rule changes propagate asynchronously.

## Cost and scenario cleanup

Premium Front Door has a significant base fee plus request/data/WAF charges; P0v3 bills continuously. Review [Front Door](https://azure.microsoft.com/pricing/details/frontdoor/) and [App Service](https://azure.microsoft.com/pricing/details/app-service/linux/) pricing. Let Terraform remove route/origin before App Service; inspect any delayed managed endpoint deletion by exact ID.

## Primary sources

- [Official reference 1](https://learn.microsoft.com/azure/frontdoor/standard-premium/how-to-enable-private-link-web-app)
- [Official reference 2](https://learn.microsoft.com/azure/frontdoor/front-door-rules-engine-actions)
- [Official reference 3](https://learn.microsoft.com/azure/frontdoor/front-door-caching)
- [Official reference 4](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/cdn_frontdoor_origin)
