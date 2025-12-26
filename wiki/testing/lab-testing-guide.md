# Lab testing guide

Use this checklist after `terraform apply` to confirm the lab is working. Run only the sections that match the features you enabled.

## Pre-flight

```bash
terraform output
az account show -o table
az group show -g rg-<prefix> -o table
```

## vWAN and vHub

```bash
az network vwan show -g rg-<prefix> -n vwan-<prefix> -o table
az network vhub show -g rg-<prefix> -n vhub-<prefix> -o table
az network vhub connection list -g rg-<prefix> --vhub-name vhub-<prefix> -o table
```

Expected:

- vWAN and vHub are Succeeded.
- Spoke2 connection exists when `deploy.vwan = true`.
- Spoke1 connection exists only when Route Server is disabled.

## Azure Firewall (if enabled)

```bash
az network firewall show -g rg-<prefix> -n fw-vhub-<prefix> -o table
az network firewall policy show -g rg-<prefix> -n fwpol-<prefix> -o table
```

Expected:

- Firewall and policy are in Succeeded state.

## VM connectivity (spoke-to-spoke)

Use Network Watcher or RunCommand to test from a VM.

```bash
# Example: test from vm-spoke1-1 to vm-spoke2-1 on RDP
az network watcher test-connectivity \
  --source-resource $(terraform output -raw vnet_spoke1_id) \
  --dest-address 10.2.1.4 --dest-port 3389 -o json
```

Expected:

- Connectivity result should be Reachable for enabled VMs.

## Route Server + BGP (if enabled)

```bash
az network routeserver show -g rg-<prefix> -n rs-<prefix> -o table
az network routeserver peering list -g rg-<prefix> --routeserver rs-<prefix> -o table

az vm run-command invoke -g rg-<prefix> -n vm-spoke1-nva \
  --command-id RunPowerShellScript \
  --scripts "Get-BgpPeer | Format-Table Name,PeerIPAddress,PeerASN,State,SessionState"
```

Expected:

- Route Server is Succeeded.
- Peers exist and are Connected.

## VPN (if enabled)

```bash
az network vhub gateway show -g rg-<prefix> -n vpngw-vhub-<prefix> -o table
az network vnet-gateway show -g rg-<prefix> -n vpngw-onprem-<prefix> -o table
az network vpn-connection show -g rg-<prefix> -n conn-onprem-to-vhub-<prefix> -o table
```

Expected:

- Gateways are Succeeded.
- VPN connection status is Connected.

## DNS and Private Endpoint (if enabled)

```bash
az network private-dns zone list -g rg-<prefix> -o table
az network private-endpoint list -g rg-<prefix> -o table

# DNS resolution test from a VM
az vm run-command invoke -g rg-<prefix> -n vm-spoke1-1 \
  --command-id RunPowerShellScript \
  --scripts "Resolve-DnsName <storage-account>.blob.core.windows.net"
```

Expected:

- Private DNS zones exist and are linked to VNets.
- Storage DNS resolves to a private IP in Spoke1.

## Edge services (optional)

Install IIS on Spoke1 VMs and validate the ILB:

```bash
az vm run-command invoke -g rg-<prefix> -n vm-spoke1-1 \
  --command-id RunPowerShellScript \
  --scripts "Install-WindowsFeature Web-Server"

# Test ILB HTTP
# Test-NetConnection -ComputerName <lb_frontend_ip> -Port 80
```

Expected:

- ILB responds on port 80 if IIS is installed.
- App Gateway responds only after backend pool targets are configured.

## Cleanup

```bash
terraform destroy -auto-approve
```

## Next

- Component checks: `component-checks.md`
- Route validation: `route-validation.md`
- DNS validation: `dns-validation.md`
- Test matrix: `test-matrix.md`
- Troubleshooting: `troubleshooting.md`
