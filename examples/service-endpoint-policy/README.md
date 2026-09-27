# Storage service endpoint policy: allowed and denied destinations

A VM subnet uses Microsoft.Storage service endpoints and a destination allow policy. Two owned Storage accounts keep their public service endpoint enabled but deny access except from this subnet. The client VM's managed identity receives the same Blob Data Reader role on both accounts, separating identity permission from destination filtering.

The policy allows Storage resources in a second dedicated owned group. Only the allowed account resides there; the denied account resides in the main example group. Group scope avoids a Terraform dependency cycle between policy account IDs and storage subnet rules. It is intentionally broader than a per-account list: any future account added to the allowed group would also be allowed.

## Configuration and prerequisites

Required providers: Microsoft.Network, Microsoft.Storage, Microsoft.Compute. Role-assignment permission is required in addition to resource creation. Supply RSA `ssh_public_key`. The VM subnet is 10.86.1.0/24. Groups are rg-<lab_id>-sep and rg-<lab_id>-sep-allowed.

There are no Private Endpoints/private zones. Storage names resolve publicly, while service endpoints identify the permitted subnet. Shared keys and anonymous blob access are disabled. Trusted-service bypass is None; its narrow Trivy exception preserves the stronger restriction.

Outputs: `storage_accounts` (allowed/denied), `client_vm_name`, `policy_id`, `client_identity_principal_id` and `allowed_storage_resource_group` plus lab/group.


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

The owned VM's cloud-init installs probe-storage.sh and a systemd service that retries at most 30 times with 30-second pauses for identity/RBAC provisioning. Account names are nonsecret template inputs. The probe obtains an IMDS storage token only at runtime; it never prints or stores the token or blob values.

~~~powershell
$group = terraform output -raw resource_group_name
$client = terraform output -raw client_vm_name
az vm boot-diagnostics get-boot-log -g $group -n $client
~~~

Require allowed HTTP 200 and denied HTTP 403 AuthorizationFailure, followed by NETWORK_LAB_PROBE PASSED. RBAC mismatch, IMDS failure, transport failure or exhausted retries are INCOMPLETE, never a passing network test. Preserve both role scopes, both subnet firewall permissions and the endpoint policy with the serial evidence.

Both storage firewalls permit this source subnet; the endpoint policy distinguishes destinations. Managed boot diagnostic collection avoids opening public SSH or relying on Run Command management egress/extension Storage dependencies. If RBAC was not ready within the bounded window, an operator can deliberately restart the owned client VM to replay the service after investigating. Do not weaken the policy or trusted-service bypass just to run a probe.

## Troubleshooting

If both fail, inspect IMDS, RBAC propagation and storage subnet rules. If both succeed, inspect policy attachment/group scope. Public-host access is not equivalent to a subnet service endpoint test. This subnet contains only the owned VM, avoiding managed-service dependencies blocked by the policy.

## Cost and scenario cleanup

One B1s VM/disk, two Storage accounts and transactions bill. Review [Storage pricing](https://azure.microsoft.com/pricing/details/storage/). Before destroy, record the second group's name. Afterwards require az group exists=false for BOTH groups. No data containers or blobs are created by the metadata-only probe.

## Primary sources

- [Official reference 1](https://learn.microsoft.com/azure/virtual-network/virtual-network-service-endpoint-policies-overview)
- [Official reference 2](https://learn.microsoft.com/azure/virtual-network/virtual-network-service-endpoint-policies)
- [Official reference 3](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/subnet_service_endpoint_storage_policy)
