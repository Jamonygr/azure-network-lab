resource "azurerm_virtual_wan" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location

  type                              = "Standard"
  disable_vpn_encryption            = false
  allow_branch_to_branch_traffic    = true
  office365_local_breakout_category = "None"

  tags = var.ctx.tags
}
