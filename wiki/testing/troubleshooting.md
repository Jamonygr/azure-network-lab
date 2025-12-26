# Troubleshooting

This page lists common failure modes and what to check first.

## General checks

- Confirm you are targeting the correct subscription: `az account show`.
- Verify resource group exists: `az group show -g rg-<prefix>`.
- Check Terraform state matches reality: `terraform state list`.

## vHub connection missing

- Ensure `deploy.vwan = true`.
- If `deploy.route_server = true`, Spoke1 is intentionally not connected.
- Re-run `terraform apply` after changing toggles.

## Firewall deployed but traffic not inspected

- Verify vHub connections show `InternetSecurityEnabled`.
- Confirm firewall policy exists and routing intent is created.
- Check that your traffic path actually traverses the hub.

## VPN connection not connected

- Confirm `vpn_shared_key` matches on both sides (vHub and on-prem).
- Check public IPs for both gateways and wait for provisioning.
- Validate BGP peer status on the on-prem gateway.

## Route Server BGP down

- Ensure `deploy.route_server = true` and `deploy.nvas = true`.
- Check the NVA VM extension output for RRAS installation.
- Verify BGP peers on the NVA: `Get-BgpPeer`.

## Private endpoint DNS resolves to public IP

- Ensure `deploy.private_dns_zones = true`.
- Confirm the private DNS zone is linked to the VNet.
- Validate the private endpoint exists in Spoke1.

## ILB not responding

- Install IIS on the backend VMs.
- Confirm VMs are attached to the LB backend pool.
- Validate NSG rules allow TCP 80.

## App Gateway returns 502

- The default module creates an empty backend pool.
- Add backend targets or wire the module to VMs before testing.

## Bastion not accessible

- Ensure `deploy.bastion = true`.
- Confirm the Bastion DNS name output is not null.

## Still stuck?

- Review `testing/component-checks.md` and rerun the relevant checks.
- Review `testing/lab-testing-guide.md` and rerun the relevant tests.
- Use `terraform plan` to confirm the desired state.
