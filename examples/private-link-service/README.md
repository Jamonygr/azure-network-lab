# Private Link Service with a functional private web backend

Create provider and consumer VNets without peering. A Standard internal load balancer sends HTTP to an owned Ubuntu VM. Private Link Service exposes the ILB through a dedicated NAT subnet; an owned consumer Private Endpoint and DNS A record map web.networklab.internal to the endpoint IP. A second private VM is the real test client.

The backend NSG allows HTTP from the PLS NAT subnet and Azure Load Balancer probes, then denies other ingress. No public VM IP or public SSH rule exists. Cloud-init starts a persistent Python/systemd responder without package downloads.

## Configuration and prerequisites

Required providers: Microsoft.Network and Microsoft.Compute. Supply an existing RSA `ssh_public_key` of at least 2048 bits; never provide a private key. Confirm B1s/Ubuntu Gen2 capacity and permission to retrieve managed boot diagnostics.

Provider=10.84.0.0/16, backend=10.84.1.0/24, PLS NAT=10.84.2.0/24, consumer=10.85.0.0/16. PLS visibility and auto-approval include only this subscription. Proxy Protocol stays disabled because the simple backend does not parse it.

Outputs: `consumer_vm_name`, `backend_vm_name`, `private_link_service_id`, `private_endpoint_ip`, `service_url` plus lab/group.


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

The consumer's cloud-init installs the checked-in probe and a systemd service. It retries at most 30 times with 30-second pauses for DNS/endpoint provisioning. It resolves the private name, performs HTTP and emits status/marker evidence to serial console; no token or secret is involved. Retrieve the exact VM's managed boot diagnostic log from the operator host:

~~~powershell
$group = terraform output -raw resource_group_name
$client = terraform output -raw consumer_vm_name
az vm boot-diagnostics get-boot-log -g $group -n $client
~~~

Require DNS equal to the exported private endpoint IP, HTTP 200 with expected_response=True, and NETWORK_LAB_PROBE PASSED. Inspect the Approved PE connection and ILB probe state as additional evidence. A retry-budget exhaustion is INCOMPLETE.

No implicit outbound, NAT gateway or public VM IP is configured. Run Command requires management outbound connectivity and is intentionally not the evidence path here. Cloud-init and managed boot diagnostics avoid that dependency. To repeat this one-shot exercise after correcting configuration, an operator may deliberately restart the owned client VM and retrieve the new log. Separately authorized private administration is required for service-stop fault injection; it is not provisioned by this root.

## Troubleshooting

Inspect cloud-init and systemd before blaming Private Link. Backend traffic arrives from the PLS NAT range, not the original consumer IP. DNS must link to the consumer VNet and resolve the PE IP. The test does not need NAT/package downloads.

## Cost and scenario cleanup

Two B1s VMs/disks, Standard ILB, PE/Private Link processing and DNS queries can bill. Review [Private Link](https://azure.microsoft.com/pricing/details/private-link/) and [Load Balancer](https://azure.microsoft.com/pricing/details/load-balancer/) pricing. Terraform dependencies remove the consumer PE before PLS/ILB.

## Primary sources

- [Official reference 1](https://learn.microsoft.com/azure/private-link/private-link-service-overview)
- [Official reference 2](https://learn.microsoft.com/azure/private-link/create-private-link-service-portal)
- [Official reference 3](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/private_link_service)
