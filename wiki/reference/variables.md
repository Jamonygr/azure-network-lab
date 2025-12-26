# Variables reference

This page summarizes the variables in `variables.tf`. Values in `terraform.tfvars` override defaults, so treat this as a contract rather than a profile.

## Top-level inputs

| Variable | Type | Default | Required | Notes |
|----------|------|---------|----------|-------|
| `subscription_id` | string | none | yes | Must be a valid GUID. |
| `ctx` | object | none | yes | Naming, location, and tags. |
| `deploy` | object | defined | no | Feature toggles for optional services. |
| `vhub_address_prefix` | string | `10.10.0.0/23` | no | vHub address prefix. |
| `spoke1_address_space` | list(string) | `10.1.0.0/16` | no | Spoke1 VNet address space. |
| `spoke2_address_space` | list(string) | `10.2.0.0/16` | no | Spoke2 VNet address space. |
| `onprem_address_space` | list(string) | `192.168.0.0/16` | no | OnPrem VNet address space. |
| `admin_username` | string | `azureadmin` | no | Admin username for all VMs. |
| `admin_password` | string | none | yes | Minimum 12 characters. |
| `vm_size` | string | `Standard_B2s` | no | VM size for all Windows VMs. |
| `vpn_shared_key` | string | `""` | no | Required when `deploy.vpn = true`. |

## ctx object

```hcl
ctx = {
  project  = "az700-lab"
  location = "eastus2"
  tags = {
    Environment = "lab"
    Project     = "az700"
  }
}
```

Validation rules:

- `ctx.project`: lowercase letters, numbers, hyphens.
- `ctx.location`: lowercase letters and numbers (e.g., `eastus2`).

## deploy object

The deploy object controls which modules run.

```hcl
deploy = {
  vwan          = true
  vhub_firewall = true
  vpn           = true
  route_server  = true

  dns_resolver      = true
  private_dns_zones = true
  bastion           = false

  application_gateway = true
  load_balancer       = true
  nat_gateway         = true

  private_endpoint = true

  spoke1_vms = true
  spoke2_vms = true
  onprem_vms = true
  nvas       = true
}
```

Notes:

- `deploy.vhub_firewall` requires `deploy.vwan = true`.
- `deploy.vpn` requires `deploy.vwan = true`.
- `deploy.private_endpoint` should be paired with `deploy.private_dns_zones`.

## Example `terraform.tfvars`

```hcl
subscription_id = "<subscription-id>"
admin_username  = "azureadmin"
admin_password  = "<secure-password>"

vpn_shared_key = "<shared-key>"
```
