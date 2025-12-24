resource "azurerm_virtual_network_gateway_connection" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location

  type                       = "IPsec"
  virtual_network_gateway_id = var.virtual_network_gateway_id
  local_network_gateway_id   = var.local_network_gateway_id

  shared_key          = var.shared_key
  enable_bgp          = var.enable_bgp
  connection_protocol = "IKEv2"

  tags = var.ctx.tags
}
