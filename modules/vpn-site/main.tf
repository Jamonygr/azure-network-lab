resource "azurerm_vpn_site" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  virtual_wan_id      = var.virtual_wan_id

  address_cidrs = var.address_cidrs

  link {
    name       = "link1"
    ip_address = var.vpn_device_ip

    bgp {
      asn             = var.bgp_asn
      peering_address = var.bgp_peering_address
    }
  }

  tags = var.ctx.tags
}

resource "azurerm_vpn_gateway_connection" "this" {
  name               = "${var.name}-connection"
  vpn_gateway_id     = var.vpn_gateway_id
  remote_vpn_site_id = azurerm_vpn_site.this.id

  vpn_link {
    name             = "link1"
    vpn_site_link_id = azurerm_vpn_site.this.link[0].id
    shared_key       = var.shared_key
    bgp_enabled      = var.bgp_enabled
  }
}
