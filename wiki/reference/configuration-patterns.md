# Reference configuration patterns

These excerpts teach interfaces beyond the main-root footprint. They are **reference configuration**, not files automatically loaded by a profile, and have not been deployed. Supply actual resource IDs in an isolated future configuration. Do not paste a route or public entry point into an existing environment without reviewing its effects.

## UDR and ASG patterns

A route table chooses a next hop; its subnet association chooses which sources use it. A group used in an NSG rule describes workload identity at the network-interface level, not a transit path.

```hcl
resource "azurerm_route_table" "inspection" {
  name                = "rt-inspection"
  location            = var.location
  resource_group_name = var.resource_group_name
  route {
    name                   = "default-via-appliance"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.appliance_private_ip
  }
}
resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = var.workload_subnet_id
  route_table_id = azurerm_route_table.inspection.id
}
resource "azurerm_application_security_group" "web" {
  name                = "asg-web"
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_network_interface_application_security_group_association" "web" {
  network_interface_id          = var.web_nic_id
  application_security_group_id = azurerm_application_security_group.web.id
}
```

An NSG rule can reference that ASG through `destination_application_security_group_ids`; scope its source and port explicitly. These resources are not claimed as main-root UDR/ASG coverage. The independent AVNM root has its own central routing configuration.

A default route needs a working forwarding appliance, policy and return path. NAT association does not override an appliance next hop.

## Public address and DNS patterns

```hcl
resource "azurerm_public_ip_prefix" "egress" {
  name                = "pip-prefix-egress"
  location            = var.location
  resource_group_name = var.resource_group_name
  prefix_length       = 30
  sku                 = "Standard"
}
resource "azurerm_public_ip" "egress" {
  name                = "pip-egress"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  public_ip_prefix_id = azurerm_public_ip_prefix.egress.id
}
resource "azurerm_dns_zone" "public" {
  name                = var.owned_public_domain
  resource_group_name = var.resource_group_name
}
resource "azurerm_dns_a_record" "web" {
  name                = "www"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.egress.ip_address]
}
```

This snippet does not own a domain, delegate it at a registrar, serve a website, attach the address to a frontend, or implement BYOIP. The [design exercise](../scenarios/design-exercises.md#byoip-and-public-prefixes) covers those decisions. A VNet's `dns_servers` can select reachable custom resolvers; omit it to use Azure-provided resolution. Review forwarding loops and platform dependencies before changing the resolver.

## Standard public LB: explicit outbound and NAT rule v2

The main root uses an internal LB. These excerpts assume a separately declared Standard **public** LB, public frontend named `public`, and backend pool. They do not add public egress to the root internal frontend.

```hcl
resource "azurerm_lb_outbound_rule" "egress" {
  name                    = "explicit-egress"
  loadbalancer_id         = var.public_lb_id
  backend_address_pool_id = var.backend_pool_id
  protocol                = "All"
  allocated_outbound_ports = 1024
  frontend_ip_configuration {
    name = "public"
  }
}
resource "azurerm_lb_nat_rule" "ssh_range" {
  name                           = "per-backend-ssh"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                 = var.public_lb_id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50099
  backend_port                   = 22
  backend_address_pool_id        = var.backend_pool_id
  frontend_ip_configuration_name = "public"
}
```

Review outbound-port capacity against backend scale and disable implicit outbound SNAT on inbound rules when the explicit outbound rule requires it. An inbound NAT mapping still requires tightly scoped NSG access. It is not permission to publish administration broadly. Prefer Bastion/private administration where suitable.

## IPsec and alternative configurations

The root connection uses its current configured policy behavior; it does not expose a custom IPsec object. This independent reference block illustrates the policy contract for an Azure VNet gateway connection. Both real peers must support and match it; these teaching settings are not a compatibility recommendation for an unknown device.

```hcl
resource "azurerm_virtual_network_gateway_connection" "reference" {
  name                       = "s2s-policy-reference"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  type                       = "IPsec"
  virtual_network_gateway_id = var.vnet_gateway_id
  local_network_gateway_id   = var.local_gateway_id
  shared_key                 = var.shared_key
  enable_bgp                 = true
  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS14"
    sa_lifetime      = 27000
    sa_datasize      = 102400000
  }
}
```

RADIUS servers, Always On clients, cross-region LB, third-party appliances and ExpressRoute require the [design worksheets](../scenarios/design-exercises.md); do not label them implemented because a related Azure resource exists.

Consult [generated module references](../../reference/root.md) and the provider schema for exact supported attributes. Every excerpt above has future dependencies and no live acceptance result.
