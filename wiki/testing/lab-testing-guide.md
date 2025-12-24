# Lab testing guide

Use this checklist after `terraform apply` to confirm the lab is working. Run only the sections that match the features you enabled.

## Pre-flight
```bash
terraform output
az account show -o table
```

## vWAN and vHub
```bash
az network vwan show -g rg-az700-lab -n vwan-az700-lab -o table
az network vhub show -g rg-az700-lab -n vhub-az700-lab -o table
az network vhub connection list -g rg-az700-lab --vhub-name vhub-az700-lab -o table
```

Expected:
- vWAN and vHub are Succeeded.
- Spoke2 connection exists when `deploy.vwan = true`.

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
az network routeserver show -g rg-az700-lab -n rs-az700-lab -o table
az network routeserver peering list -g rg-az700-lab --routeserver rs-az700-lab -o table

az vm run-command invoke -g rg-az700-lab -n vm-spoke1-nva \
  --command-id RunPowerShellScript \
  --scripts "Get-BgpPeer | Format-Table Name,PeerIPAddress,PeerASN,State,SessionState"
```

Expected:
- Route Server is Succeeded.
- Peers exist for the Route Server IPs.

## VPN (if enabled)
```bash
az network vhub gateway show -g rg-az700-lab -n vpngw-vhub-az700-lab -o table
az network vnet-gateway show -g rg-az700-lab -n vpngw-onprem-az700-lab -o table
az network vpn-connection show -g rg-az700-lab -n conn-onprem-to-vhub-az700-lab -o table
```

Expected:
- Gateways are Succeeded.
- VPN connection status is Connected.

## DNS and Private Endpoint (if enabled)
```bash
az network private-dns zone list -g rg-az700-lab -o table
az network private-endpoint list -g rg-az700-lab -o table

# DNS resolution test from a VM
az vm run-command invoke -g rg-az700-lab -n vm-spoke1-1 \
  --command-id RunPowerShellScript \
  --scripts "Resolve-DnsName <storage-account>.blob.core.windows.net"
```

Expected:
- Private DNS zones exist and are linked to VNets.
- Storage DNS resolves to a private IP in Spoke1.

## Load Balancer or App Gateway (optional)
If you install IIS or a custom service on the workload VMs, validate HTTP:

```powershell
Test-NetConnection -ComputerName <lb_frontend_ip> -Port 80
```

## Cleanup
```bash
terraform destroy -auto-approve
```
