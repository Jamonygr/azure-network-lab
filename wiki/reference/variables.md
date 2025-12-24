# Variables reference

This page summarizes the core inputs used by the lab. See `variables.tf` for the full contract.

## ctx (required)
The shared context object for all modules.

```hcl
ctx = {
  project  = "az700-lab"
  location = "eastus2"
  tags = {
    Environment = "lab"
    Project     = "az700"
    Owner       = "Your Name"
  }
}
```

- `project` must be lowercase letters, numbers, and hyphens.
- `location` must be lowercase letters and numbers (e.g., `eastus2`).

## deploy (feature toggles)
The master control panel that enables/disables components.

```hcl
deploy = {
  vwan          = true
  vhub_firewall = true
  vpn           = false
  route_server  = true

  dns_resolver      = true
  private_dns_zones = true
  bastion           = false

  application_gateway = false
  load_balancer       = true
  nat_gateway         = true

  private_endpoint = true

  spoke1_vms = true
  spoke2_vms = true
  onprem_vms = false
  nvas       = true
}
```

## Address spaces
```hcl
vhub_address_prefix  = "10.10.0.0/23"
spoke1_address_space = ["10.1.0.0/16"]
spoke2_address_space = ["10.2.0.0/16"]
onprem_address_space = ["192.168.0.0/16"]
```

## VM settings
```hcl
admin_username = "azureadmin"
admin_password = "YourSecureP@ssw0rd!"
vm_size        = "Standard_B1ms"
```

## VPN settings
```hcl
vpn_shared_key = "YourVPNSharedKey123!"
```

- `vpn_shared_key` is required when `deploy.vpn = true`.
