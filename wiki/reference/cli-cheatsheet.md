# CLI cheat sheet

Quick commands for common lab operations. Replace `<prefix>` with your `ctx.project` value.

## Terraform

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform output
```

## Core networking

```bash
az network vwan show -g rg-<prefix> -n vwan-<prefix> -o table
az network vhub show -g rg-<prefix> -n vhub-<prefix> -o table
az network vhub connection list -g rg-<prefix> --vhub-name vhub-<prefix> -o table
```

## Firewall

```bash
az network firewall show -g rg-<prefix> -n fw-vhub-<prefix> -o table
az network firewall policy show -g rg-<prefix> -n fwpol-<prefix> -o table
```

## Route Server

```bash
az network routeserver show -g rg-<prefix> -n rs-<prefix> -o table
az network routeserver peering list -g rg-<prefix> --routeserver rs-<prefix> -o table
```

## VPN

```bash
az network vhub gateway show -g rg-<prefix> -n vpngw-vhub-<prefix> -o table
az network vnet-gateway show -g rg-<prefix> -n vpngw-onprem-<prefix> -o table
az network vpn-connection show -g rg-<prefix> -n conn-onprem-to-vhub-<prefix> -o table
```

## DNS and private endpoint

```bash
az network private-dns zone list -g rg-<prefix> -o table
az network private-endpoint list -g rg-<prefix> -o table
```

## VNet peerings and NSGs

```bash
az network vnet peering list -g rg-<prefix> --vnet-name vnet-spoke1-<prefix> -o table
az network nsg rule list -g rg-<prefix> --nsg-name nsg-spoke1-<prefix> -o table
```

## VM checks

```bash
az vm list -g rg-<prefix> -o table
az vm run-command invoke -g rg-<prefix> -n vm-spoke1-1 \
  --command-id RunPowerShellScript \
  --scripts "Get-NetIPAddress"
```

## Cleanup

```bash
terraform destroy -auto-approve
```
