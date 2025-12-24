# =============================================================================
# AZ-700 Azure Networking Lab - Root Orchestrator (single environment)
# =============================================================================

module "tags" {
  source = "./modules/tags"

  required_keys = local.required_tag_keys
  defaults      = local.default_tags
  extra         = var.ctx.tags
}

module "resource_group" {
  source = "./modules/resource-group"

  name = "rg-${local.prefix}"
  ctx  = local.ctx
}

module "log_analytics" {
  source = "./modules/log-analytics"

  name                = "log-${local.prefix}"
  resource_group_name = module.resource_group.name
  retention_in_days   = 30
  ctx                 = local.ctx
}

# =============================================================================
# Virtual WAN Core
# =============================================================================

module "vwan" {
  count  = var.deploy.vwan ? 1 : 0
  source = "./modules/vwan"

  name                = "vwan-${local.prefix}"
  resource_group_name = module.resource_group.name
  ctx                 = local.ctx
}

module "vhub" {
  count  = var.deploy.vwan ? 1 : 0
  source = "./modules/vhub"

  name                = "vhub-${local.prefix}"
  resource_group_name = module.resource_group.name
  virtual_wan_id      = local.vwan_id
  address_prefix      = var.vhub_address_prefix
  ctx                 = local.ctx
}

module "vhub_firewall" {
  count  = var.deploy.vwan && var.deploy.vhub_firewall ? 1 : 0
  source = "./modules/vhub-firewall"

  name                = "fw-vhub-${local.prefix}"
  policy_name         = "fwpol-${local.prefix}"
  resource_group_name = module.resource_group.name
  virtual_hub_id      = local.vhub_id
  ctx                 = local.ctx
}

module "vhub_vpn_gateway" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/vhub-vpn-gateway"

  name                = "vpngw-vhub-${local.prefix}"
  resource_group_name = module.resource_group.name
  virtual_hub_id      = local.vhub_id
  scale_unit          = 1
  ctx                 = local.ctx
}

# =============================================================================
# VNets, NSGs, and Peerings
# =============================================================================

module "vnet" {
  for_each = local.vnets
  source   = "./modules/vnet"

  name                = each.value.name
  resource_group_name = module.resource_group.name
  address_space       = each.value.address_space
  subnets             = each.value.subnets
  ctx                 = local.ctx
}

module "vnet_peering" {
  for_each = local.vnet_peerings_enabled
  source   = "./modules/vnet-peering"

  name                         = each.value.name
  resource_group_name          = module.resource_group.name
  virtual_network_name         = module.vnet[each.value.vnet_key].name
  remote_virtual_network_id    = module.vnet[each.value.remote_vnet_key].id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
  ctx                          = local.ctx
}

module "nsg" {
  for_each = local.nsgs
  source   = "./modules/nsg"

  name                = each.value.name
  resource_group_name = module.resource_group.name
  subnet_associations = {
    for subnet_name in each.value.subnet_names :
    subnet_name => module.vnet[each.value.vnet_key].subnet_ids[subnet_name]
  }
  security_rules = each.value.rules
  ctx            = local.ctx
}

# =============================================================================
# vHub Connections
# =============================================================================

module "vhub_connection" {
  for_each = local.vhub_connections_enabled
  source   = "./modules/vhub-connection"

  name                      = each.value.name
  virtual_hub_id            = local.vhub_id
  remote_virtual_network_id = module.vnet[each.value.vnet_key].id
  internet_security_enabled = each.value.internet_security_enabled
  ctx                       = local.ctx

  depends_on = [module.vhub_firewall]
}

# =============================================================================
# VPN Infrastructure
# =============================================================================

module "vpn_gateway_onprem" {
  count  = var.deploy.vpn ? 1 : 0
  source = "./modules/vpn-gateway"

  name                = "vpngw-onprem-${local.prefix}"
  resource_group_name = module.resource_group.name
  gateway_subnet_id   = module.vnet["onprem"].subnet_ids["GatewaySubnet"]
  sku                 = "VpnGw1"
  enable_bgp          = true
  bgp_asn             = 65510
  ctx                 = local.ctx
}

module "vpn_site_onprem" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/vpn-site"

  name                = "site-onprem-${local.prefix}"
  resource_group_name = module.resource_group.name
  virtual_wan_id      = local.vwan_id
  vpn_gateway_id      = module.vhub_vpn_gateway[0].id
  address_cidrs       = var.onprem_address_space
  vpn_device_ip       = module.vpn_gateway_onprem[0].public_ip_address
  shared_key          = var.vpn_shared_key
  bgp_enabled         = true
  bgp_asn             = 65510
  bgp_peering_address = module.vpn_gateway_onprem[0].bgp_peering_address
  ctx                 = local.ctx

  depends_on = [module.vpn_gateway_onprem, module.vhub_vpn_gateway]
}

module "local_network_gateway_vhub" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/local-network-gateway"

  name                = "lng-vhub-${local.prefix}"
  resource_group_name = module.resource_group.name
  gateway_address     = local.vhub_gateway_tunnel_ip
  address_space       = ["10.0.0.0/8"]
  bgp_enabled         = true
  bgp_asn             = 65515
  bgp_peering_address = local.vhub_gateway_default_ip
  ctx                 = local.ctx

  depends_on = [module.vhub_vpn_gateway]
}

module "vpn_connection_onprem_to_vhub" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/vpn-connection"

  name                       = "conn-onprem-to-vhub-${local.prefix}"
  resource_group_name        = module.resource_group.name
  virtual_network_gateway_id = module.vpn_gateway_onprem[0].id
  local_network_gateway_id   = module.local_network_gateway_vhub[0].id
  shared_key                 = var.vpn_shared_key
  enable_bgp                 = true
  ctx                        = local.ctx

  depends_on = [
    module.vpn_gateway_onprem,
    module.local_network_gateway_vhub,
    module.vpn_site_onprem
  ]
}

# =============================================================================
# Route Server
# =============================================================================

module "route_server" {
  count  = var.deploy.route_server ? 1 : 0
  source = "./modules/route-server"

  name                             = "rs-${local.prefix}"
  resource_group_name              = module.resource_group.name
  subnet_id                        = module.vnet["spoke1"].subnet_ids["RouteServerSubnet"]
  branch_to_branch_traffic_enabled = true
  bgp_connections                  = local.route_server_bgp_connections
  ctx                              = local.ctx
}

# =============================================================================
# DNS
# =============================================================================

module "private_dns_zone" {
  for_each = local.private_dns_zones_enabled
  source   = "./modules/private-dns-zone"

  name                = each.value.name
  resource_group_name = module.resource_group.name
  virtual_network_links = {
    for key in local.vnet_link_keys :
    key => module.vnet[key].id
  }
  registration_enabled = each.value.registration_enabled
  ctx                  = local.ctx
}

module "dns_resolver" {
  count  = var.deploy.dns_resolver ? 1 : 0
  source = "./modules/dns-private-resolver"

  name                = "dnspr-${local.prefix}"
  resource_group_name = module.resource_group.name
  virtual_network_id  = module.vnet["spoke1"].id
  inbound_subnet_id   = module.vnet["spoke1"].subnet_ids["DnsResolverInbound"]
  outbound_subnet_id  = module.vnet["spoke1"].subnet_ids["DnsResolverOutbound"]
  ctx                 = local.ctx
}

# =============================================================================
# Compute Support Services
# =============================================================================

module "load_balancer" {
  count  = var.deploy.load_balancer ? 1 : 0
  source = "./modules/load-balancer"

  name                = "ilb-${local.prefix}"
  resource_group_name = module.resource_group.name
  subnet_id           = module.vnet["spoke1"].subnet_ids["LoadBalancerSubnet"]
  ctx                 = local.ctx
}

module "application_gateway" {
  count  = var.deploy.application_gateway ? 1 : 0
  source = "./modules/application-gateway"

  name                = "appgw-${local.prefix}"
  resource_group_name = module.resource_group.name
  subnet_id           = module.vnet["spoke1"].subnet_ids["AppGwSubnet"]
  sku_name            = "WAF_v2"
  sku_tier            = "WAF_v2"
  capacity            = 1
  waf_enabled         = true
  ctx                 = local.ctx
}

module "nat_gateway" {
  count  = var.deploy.nat_gateway ? 1 : 0
  source = "./modules/nat-gateway"

  name                = "nat-${local.prefix}"
  resource_group_name = module.resource_group.name
  subnet_associations = {
    "Workload" = module.vnet["spoke1"].subnet_ids["Workload"]
  }
  ctx = local.ctx
}

module "bastion" {
  count  = var.deploy.bastion ? 1 : 0
  source = "./modules/bastion"

  name                = "bas-${local.prefix}"
  resource_group_name = module.resource_group.name
  subnet_id           = module.vnet["spoke1"].subnet_ids["AzureBastionSubnet"]
  sku                 = "Basic"
  ctx                 = local.ctx
}

# =============================================================================
# Private Endpoints
# =============================================================================

module "storage_account" {
  count  = var.deploy.private_endpoint ? 1 : 0
  source = "./modules/storage-account"

  name_prefix                   = local.storage_account_name_prefix
  resource_group_name           = module.resource_group.name
  public_network_access_enabled = false
  allow_public_network_access   = false
  ctx                           = local.ctx
}

module "private_endpoint_storage" {
  count  = var.deploy.private_endpoint && var.deploy.private_dns_zones ? 1 : 0
  source = "./modules/private-endpoint"

  name                           = "pe-storage-${local.prefix}"
  resource_group_name            = module.resource_group.name
  subnet_id                      = module.vnet["spoke1"].subnet_ids["PrivateEndpointSubnet"]
  private_connection_resource_id = module.storage_account[0].id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = var.deploy.private_dns_zones ? [module.private_dns_zone["blob"].id] : []
  ctx                            = local.ctx
}

# =============================================================================
# Virtual Machines
# =============================================================================

module "vm_windows" {
  for_each = local.vm_windows_enabled
  source   = "./modules/vm-windows"

  name                 = each.value.name
  resource_group_name  = module.resource_group.name
  subnet_id            = module.vnet[each.value.vnet_key].subnet_ids[each.value.subnet_name]
  size                 = var.vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  join_lb_backend_pool = each.value.join_lb_backend_pool
  lb_backend_pool_id   = each.value.join_lb_backend_pool ? try(module.load_balancer[0].backend_pool_id, null) : null
  ctx                  = local.ctx

  depends_on = [module.nsg]
}

module "vm_nva" {
  for_each = local.vm_nva_enabled
  source   = "./modules/vm-windows-nva"

  name                = each.value.name
  resource_group_name = module.resource_group.name
  subnet_id           = module.vnet[each.value.vnet_key].subnet_ids[each.value.subnet_name]
  private_ip_address  = each.value.private_ip
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  bgp_asn             = each.value.bgp_asn
  route_server_ips    = var.deploy.route_server ? try(module.route_server[0].virtual_router_ips, []) : []
  advertised_routes   = each.value.advertised_routes
  ctx                 = local.ctx

  depends_on = [module.nsg, module.route_server]
}
