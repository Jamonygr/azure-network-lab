# Scenario: Private endpoints + DNS

## Goal
Validate private endpoint connectivity and DNS resolution for the storage account.

## Required toggles
- `deploy.private_dns_zones = true`
- `deploy.private_endpoint = true`

## Steps
1. Confirm Private DNS zones and VNet links.
2. Check storage private endpoint and its IP address.
3. Validate DNS resolution from a workload VM.

## Commands
```bash
# Private DNS zones
az network private-dns zone list -g rg-az700-lab -o table

# Private endpoint
az network private-endpoint list -g rg-az700-lab -o table

# DNS resolution test (RunCommand)
az vm run-command invoke -g rg-az700-lab -n vm-spoke1-1 \
  --command-id RunPowerShellScript \
  --scripts "Resolve-DnsName <storage-account>.blob.core.windows.net"
```

## Expected results
- Private DNS zones are linked to spokes.
- Storage private endpoint has a private IP in Spoke1.
- DNS resolves to a private IP (not a public IP).
