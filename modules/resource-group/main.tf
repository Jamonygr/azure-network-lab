resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.ctx.location
  tags     = var.ctx.tags
}
