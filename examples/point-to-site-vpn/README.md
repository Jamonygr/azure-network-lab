# Point-to-site OpenVPN with Microsoft Entra authentication

Provision VpnGw1AZ, a zone-redundant Standard public IP and dedicated /27 GatewaySubnet with OpenVPN/Entra client authentication. A private Ubuntu HTTP VM gives the client a real target. Its NSG permits HTTP only from the VPN client pool. No password, shared secret or client certificate is generated.

Tenant app approval/assignment, Conditional Access, Azure VPN Client installation/profile import and interactive sign-in are explicit operator tasks beyond gateway provisioning.

## Configuration and prerequisites

Required providers: Microsoft.Network and Microsoft.Compute. Select a zone-supporting region with VpnGw1AZ/B1s capacity. Supply RSA `ssh_public_key` and explicit `vpn_aad_audience`, `vpn_aad_tenant_url`=https://login.microsoftonline.com/<tenant>, `vpn_aad_issuer_url`=https://sts.windows.net/<tenant>/. Select the approved application audience from current Microsoft guidance; do not copy another cloud's/legacy app ID.

`vpn_client_address_pool` defaults to 172.28.10.0/24. Validation requires canonical private IPv4 /16-/29 and rejects numeric overlap with lab 10.88.0.0/16. Check all other client/on-prem networks manually. Outputs: `gateway_name`, `gateway_id`, `gateway_public_ip`, `target_url`, `target_vm_name` plus lab/group.


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

Follow the current Entra/OpenVPN instructions below to download the exact gateway's client profile, import it into Azure VPN Client and sign in with an assigned tenant user.

~~~powershell
Get-NetRoute -AddressFamily IPv4 | Where-Object DestinationPrefix -eq "10.88.0.0/16"
Test-NetConnection 10.88.1.10 -Port 80
curl.exe http://10.88.1.10/
~~~

Record successful sign-in, assigned client-pool address, route and body network-lab-private-http. Disconnect and confirm that the target is unreachable from a host with no alternate route. A downloaded profile or provisioned gateway alone does not pass.

Use the owned target's managed boot diagnostic log for bootstrap evidence. Separately authorized private administration is needed to run `systemctl status network-lab-http` if needed; there is no public target IP/SSH exception.

## Troubleshooting

Provisioning can take tens of minutes. Check audience, tenant/issuer and app assignment in Entra sign-in logs for auth failures. Check route overlap/imported profile for data failures. Keep GatewaySubnet free of NSGs/UDRs. Reimport profiles after gateway changes.

## Cost and scenario cleanup

VpnGw1AZ bills while provisioned with no active clients. Public IP, B1s VM/disk and egress also bill; review [VPN Gateway pricing](https://azure.microsoft.com/pricing/details/vpn-gateway/). Disconnect/remove the client profile during cleanup. The shared tenant VPN app is not owned/deleted by this root. Do not interrupt long gateway deletion and discard state.

## Primary sources

- [Official reference 1](https://learn.microsoft.com/azure/vpn-gateway/point-to-site-entra-gateway)
- [Official reference 2](https://learn.microsoft.com/azure/vpn-gateway/point-to-site-about)
- [Official reference 3](https://learn.microsoft.com/azure/vpn-gateway/about-zone-redundant-vnet-gateways)
- [Official reference 4](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/virtual_network_gateway)
