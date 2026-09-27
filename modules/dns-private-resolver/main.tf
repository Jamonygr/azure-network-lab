resource "azurerm_private_dns_resolver" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  virtual_network_id  = var.virtual_network_id

  tags = var.ctx.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = "${var.name}-inbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.ctx.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = var.inbound_subnet_id
  }

  tags = var.ctx.tags
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {
  name                    = "${var.name}-outbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.ctx.location
  subnet_id               = var.outbound_subnet_id

  tags = var.ctx.tags
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  name                                       = "${var.name}-ruleset"
  resource_group_name                        = var.resource_group_name
  location                                   = var.ctx.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.this.id]
  tags                                       = var.ctx.tags
}
resource "azurerm_private_dns_resolver_forwarding_rule" "this" {
  for_each                  = var.forwarding_rules
  name                      = each.key
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  domain_name               = each.value.domain_name
  enabled                   = each.value.enabled
  dynamic "target_dns_servers" {
    for_each = each.value.target_dns_servers
    content {
      ip_address = target_dns_servers.value.ip_address
      port       = target_dns_servers.value.port
    }
  }
  lifecycle {
    precondition {
      condition     = alltrue([for server in each.value.target_dns_servers : server.ip_address != azurerm_private_dns_resolver_inbound_endpoint.this.ip_configurations[0].private_ip_address])
      error_message = "A forwarding rule must not loop back to this resolver's own inbound endpoint."
    }
  }
}
resource "azurerm_private_dns_resolver_virtual_network_link" "this" {
  for_each                  = var.forwarding_vnet_links
  name                      = "link-${each.key}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id        = each.value
}
