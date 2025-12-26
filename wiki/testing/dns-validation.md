# DNS validation

Use these checks to confirm private DNS zones, VNet links, and private endpoint resolution.

## DNS zones and links

```bash
az network private-dns zone list -g rg-<prefix> -o table
az network private-dns link vnet list -g rg-<prefix> -z lab.internal -o table
az network private-dns link vnet list -g rg-<prefix> -z privatelink.blob.core.windows.net -o table
```

Expected:

- Both zones exist when `deploy.private_dns_zones = true`.
- VNets are linked to both zones.

## Private endpoint records

```bash
az network private-dns record-set a list \
  -g rg-<prefix> -z privatelink.blob.core.windows.net -o table
```

Expected:

- An A record exists for the storage account private endpoint.

## VM resolution test

```bash
az vm run-command invoke -g rg-<prefix> -n vm-spoke1-1 \
  --command-id RunPowerShellScript \
  --scripts "Resolve-DnsName <storage-account>.blob.core.windows.net"
```

Expected:

- DNS resolves to a private IP in Spoke1.

## DNS Private Resolver (optional)

```bash
az resource list -g rg-<prefix> --resource-type Microsoft.Network/dnsResolvers -o table
```

Expected:

- DNS Private Resolver exists when `deploy.dns_resolver = true`.
