resource "azurerm_vpn_gateway" "this" {
  name                = var.name
  location            = var.ctx.location
  resource_group_name = var.resource_group_name
  virtual_hub_id      = var.virtual_hub_id

  scale_unit = var.scale_unit

  bgp_settings {
    asn         = 65515
    peer_weight = 0
  }

  tags = var.ctx.tags
}
