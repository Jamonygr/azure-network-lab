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
