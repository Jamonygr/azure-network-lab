resource "azurerm_virtual_hub" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  virtual_wan_id      = var.virtual_wan_id
  address_prefix      = var.address_prefix

  sku = "Standard"

  tags = var.ctx.tags
}
