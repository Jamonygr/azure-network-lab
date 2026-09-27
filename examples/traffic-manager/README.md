# Traffic Manager with owned regional App Services

Create two Standard S1 Linux App Services and a Traffic Manager DNS profile. Both apps run a small Node 22 responder identifying their region. HTTPS probes govern health. Select Priority, Weighted, Geographic or Performance routing.

Traffic Manager returns DNS answers; it does not proxy HTTP or terminate TLS. This root tests routing and the apps' valid default TLS endpoints. An HTTPS request to `trafficmanager.net` is not a valid custom-domain TLS test.

## Configuration and prerequisites

Required providers: Microsoft.Network and Microsoft.Web. App Service's native Traffic Manager integration requires Standard/Premium, so this example uses S1 in both regions.

Extra inputs: `secondary_location`=northeurope (must differ), `routing_method`=Priority, `endpoint_weights`={primary=80,secondary=20}, `geographic_mappings`={primary=[GEO-EU],secondary=[WORLD]}. WORLD catches locations without a more-specific match. Choose valid geography codes without duplicate assignments. Outputs: `traffic_manager_fqdn`, `profile_id`, `regional_urls`, `routing_method` plus lab/group.


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

~~~powershell
$name = terraform output -raw traffic_manager_fqdn
$urls = terraform output -json regional_urls | ConvertFrom-Json
Resolve-DnsName $name
curl.exe $urls.primary
curl.exe $urls.secondary
~~~

Expect distinct regional markers and valid HTTPS at both app names. Check monitor status before judging routing. For Priority, stop only this example's primary web app in the portal, wait for unhealthy probes plus DNS TTL/cache expiry, and observe the alternate answer. Restart the app and record recovery.

For Weighted, use independent resolvers/clients; repeatedly querying one cached resolver does not establish an 80/20 distribution. For Geographic, test Europe and the WORLD fallback from appropriate resolver locations. A failed geographically selected endpoint does not automatically use another geography; nested profiles are a separate design. For Performance, compare answers from different resolver regions; Azure's latency table governs selection.

Record UTC times, TTL/answers, health and app responses. End-to-end same-hostname HTTPS additionally requires an owned custom domain and valid TLS/hostname bindings on both apps, which are outside this root. Never disable HTTPS or certificate checks to conceal a hostname mismatch.

## Troubleshooting

Inspect resolver caching and endpoint health before changing routing. Ensure plans remain Standard/Premium. Requests to the Traffic Manager domain can fail TLS because DNS routing does not supply a certificate; follow the returned app hostname for this exercise.

## Cost and scenario cleanup

Two independent S1 plans bill continuously, plus Traffic Manager queries/monitoring. Review [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/). Restore apps stopped for failure tests, then remove profile and both regional plans using this state.

## Primary sources

- [Official reference 1](https://learn.microsoft.com/azure/app-service/web-sites-traffic-manager)
- [Official reference 2](https://learn.microsoft.com/azure/traffic-manager/traffic-manager-routing-methods)
- [Official reference 3](https://learn.microsoft.com/azure/traffic-manager/traffic-manager-how-it-works)
- [Official reference 4](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/traffic_manager_azure_endpoint)
