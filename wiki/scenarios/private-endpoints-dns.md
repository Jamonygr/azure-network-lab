# Scenario: Private endpoints and DNS

<p align="center">
  <img src="../images/scenarios-private-endpoints-dns.svg" alt="Scenario: Private endpoints and DNS banner" width="1000" />
</p>


## Goal

Validate that the storage account is private, a private endpoint exists, and DNS resolves to the private IP.

## Required toggles

- `deploy.private_endpoint = true`
- `deploy.private_dns_zones = true`

## Optional toggles

- `deploy.dns_resolver = true` for DNS resolver endpoints.

## Steps

1. Apply the lab and capture outputs.
2. Confirm private DNS zones and VNet links exist.
3. Confirm the storage private endpoint exists.
4. Validate DNS resolution from a VM.

## Commands

```bash
az network private-dns zone list -g rg-<prefix> -o table
az network private-endpoint list -g rg-<prefix> -o table
az storage account show -g rg-<prefix> -n <storage-account> -o table

# DNS resolution from a VM
az vm run-command invoke -g rg-<prefix> -n vm-spoke1-1 \
  --command-id RunPowerShellScript \
  --scripts "Resolve-DnsName <storage-account>.blob.core.windows.net"
```

## Expected results

- Private DNS zones exist and link to VNets.
- Storage account has public access disabled.
- DNS resolves to the private endpoint IP.

## Notes

- Replace `<prefix>` with `ctx.project`.
- Storage account name is available via `terraform output storage_account_name`.
- Ensure the VM used for testing is deployed and reachable.

## Related pages

- [DNS and Private Link](../architecture/dns-and-private-link.md)
- [DNS validation](../testing/dns-validation.md)
- [Ports and protocols](../reference/ports-and-protocols.md)
- [Defaults and SKUs](../reference/defaults-and-skus.md)
