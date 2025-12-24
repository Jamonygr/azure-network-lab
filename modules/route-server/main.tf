resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = var.ctx.tags
}

resource "azurerm_route_server" "this" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.ctx.location
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.this.id
  subnet_id                        = var.subnet_id
  branch_to_branch_traffic_enabled = var.branch_to_branch_traffic_enabled

  tags = var.ctx.tags
}

resource "azurerm_route_server_bgp_connection" "this" {
  for_each = var.bgp_connections

  name            = each.key
  route_server_id = azurerm_route_server.this.id
  peer_asn        = each.value.peer_asn
  peer_ip         = each.value.peer_ip
}
