# Virtual Network Manager: connectivity, admin rules and routing

Deploy a hub-and-spoke connectivity configuration, Internet RDP-deny security admin rule and discard-route configuration. The root owns one hub and two spokes. A static network group includes only those two spokes; there is no dynamic policy membership. Configuration resources **and regional deployment resources** exist for all three configuration types, with complete resource objects hashed into redeployment triggers.

Manager scope is the selected subscription because AVNM supports subscription/management-group scope. Membership and deployment targets remain the owned VNets. Creating the manager requires corresponding subscription-scope network permissions. Existing peerings are never requested for deletion.

## Configuration and prerequisites

Only common inputs are required. Hub=10.80.0.0/16, spokes=10.81.0.0/16 and 10.82.0.0/16; each has a workload /24 with implicit outbound disabled. These VNets have no peering to the main repository topology.

Required provider: Microsoft.Network. Confirm Connectivity, SecurityAdmin and Routing availability in the chosen region. Outputs: `network_manager_id`, `vnet_ids`, `deployment_ids`, `resource_group_name`, `lab_id`.


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

1. Capture all three regional deployment IDs and successful deployment status. A configuration definition alone is insufficient.
2. Inspect effective membership of `disposable-spokes`: exactly the two exported spoke IDs.
3. Inspect managed hub peerings and confirm direct spoke group connectivity is None.
4. Inspect the effective security admin rule: Internet TCP/3389 is Deny.
5. Inspect generated routes: 192.0.2.0/24 has NoNextHop. This reserved documentation prefix is intentionally harmless.
6. Change an admin-rule source/protocol or connectivity setting, review a new plan, and confirm the corresponding deployment trigger changes.

No VM clients exist in this root. Effective-NIC-route and packet-delivery tests remain NOT_RUN until separately authorized disposable hosts exist; deployment status alone does not prove packet delivery.

## Troubleshooting

Check regional deployment status, effective group membership, propagation and subscription-scope permissions. Resource-group Contributor alone may be insufficient. Do not widen to a management group to bypass a permissions problem.

## Cost and scenario cleanup

AVNM can charge per managed VNet/features plus peering transfer. Review [AVNM pricing](https://azure.microsoft.com/pricing/details/virtual-network-manager/). Terraform destroys deployment resources before child configurations and owned VNets; verify managed artifacts disappear with them.

## Primary sources

- [Official reference 1](https://learn.microsoft.com/azure/virtual-network-manager/overview)
- [Official reference 2](https://learn.microsoft.com/azure/virtual-network-manager/concept-connectivity-configuration)
- [Official reference 3](https://learn.microsoft.com/azure/virtual-network-manager/concept-security-admins)
- [Official reference 4](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/network_manager_routing_configuration)
