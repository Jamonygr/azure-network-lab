# Explicit opt-in DDoS Network Protection and monitoring

Create a dedicated DDoS Network Protection plan and owned VNet. A Standard public IP attached to a VM NIC inherits the VNet's protection. The target NSG denies all inbound traffic; no public administration/web service is enabled. Log Analytics receives the IP's DDoS notifications, mitigation flow logs/reports and metrics. An alert watches IfUnderDDoSAttack > 0.

This is protection/monitoring configuration, not a mitigation efficacy demonstration. No attack traffic or simulation is generated. An idle lab normally has no mitigation events.

## Configuration and prerequisites

Required providers: Microsoft.Network, Microsoft.Compute, Microsoft.OperationalInsights and Microsoft.Insights. Supply RSA `ssh_public_key`. The VNet is 10.89.0.0/16. Optional `alert_email` defaults empty: the metric alert exists but no recipient is invented/contacted. Explicitly supplying your own address creates an action group for future real alerts.

Outputs: `protection_plan_id`, `protected_public_ip_id`, `protected_public_ip`, `workspace_name`, `attack_alert_id` and `email_notifications_configured` plus lab/group.


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

1. Record the VNet plan association and public IP inherited protection mode. The IP must be attached to the target NIC, not merely allocated.
2. Inspect DDoS metric availability/protection status without generating load.
3. Verify the diagnostic destination and all three DDoS categories.
4. Record alert threshold/frequency and receiver state. Empty alert_email means notifications are NOT_CONFIGURED.
5. Inspect real events only if they exist:

~~~kusto
AzureDiagnostics
| where Category in ("DDoSProtectionNotifications", "DDoSMitigationFlowLogs", "DDoSMitigationReports")
| project TimeGenerated, Category, ResourceId
| order by TimeGenerated desc
~~~

An idle lab validates configuration and metric availability only. Any sanctioned simulation would need a separately approved scope and Microsoft's supported simulation process; this root contains no flood tooling.

## Troubleshooting

Empty mitigation logs while idle are expected. For missing metrics, inspect NIC/IP association, VNet plan/provisioning and ingestion. Delivery cannot be claimed without a configured receiver and an actual alert.

## Cost and scenario cleanup

**Very high cost compared with the other examples.** Network Protection has a substantial plan charge/billing commitment; brief deployment does not guarantee a negligible bill. Review current [DDoS pricing](https://azure.microsoft.com/pricing/details/ddos-protection/) and subscription terms before opt-in. VM/disk/PIP, metrics/alerts and Log Analytics also bill. Destroy association/VM/IP before the plan. Retained workspace data and billing commitments are separate from active cleanup.

## Primary sources

- [Official reference 1](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-overview)
- [Official reference 2](https://learn.microsoft.com/azure/ddos-protection/telemetry)
- [Official reference 3](https://learn.microsoft.com/azure/ddos-protection/alerts)
- [Official reference 4](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/network_ddos_protection_plan)
