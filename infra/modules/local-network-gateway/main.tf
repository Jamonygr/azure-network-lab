resource "azurerm_local_network_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  gateway_address = var.gateway_address
  address_space   = var.address_space

  dynamic "bgp_settings" {
    for_each = var.bgp_enabled ? [1] : []
    content {
      asn                 = var.bgp_asn
      bgp_peering_address = var.bgp_peering_address
    }
  }

  tags = var.tags
}
