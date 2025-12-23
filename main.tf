# =============================================================================
# AZ-700 Azure Networking Lab - Main Configuration
# =============================================================================
# This lab deploys a vWAN-centric networking environment for AZ-700 exam prep
# Deployment order optimized for logical dependencies
# =============================================================================

# =============================================================================
# PHASE 1: FOUNDATION
# =============================================================================

# -----------------------------------------------------------------------------
# Resource Group
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

# -----------------------------------------------------------------------------
# Log Analytics Workspace
# -----------------------------------------------------------------------------

module "log_analytics" {
  source = "./modules/log-analytics"

  name                = "log-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  retention_in_days   = 30
  tags                = local.common_tags
}

# =============================================================================
# PHASE 2: VIRTUAL WAN CORE (Deploy early - takes longest)
# =============================================================================

# -----------------------------------------------------------------------------
# Virtual WAN
# -----------------------------------------------------------------------------

module "vwan" {
  count  = var.deploy.vwan ? 1 : 0
  source = "./modules/vwan"

  name                = "vwan-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# Virtual Hub
# -----------------------------------------------------------------------------

module "vhub" {
  count  = var.deploy.vwan ? 1 : 0
  source = "./modules/vhub"

  name                = "vhub-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_wan_id      = module.vwan[0].id
  address_prefix      = var.vhub_address_prefix
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# Azure Firewall in vHub (Secured Hub) - Deploy early, takes ~10 mins
# -----------------------------------------------------------------------------

module "vhub_firewall" {
  count  = var.deploy.vwan && var.deploy.vhub_firewall ? 1 : 0
  source = "./modules/vhub-firewall"

  name                = "fw-vhub-${local.name_prefix}"
  policy_name         = "fwpol-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_hub_id      = module.vhub[0].id
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# vHub VPN Gateway - Deploy early, takes ~30 mins
# -----------------------------------------------------------------------------

module "vhub_vpn_gateway" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/vhub-vpn-gateway"

  name                = "vpngw-vhub-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_hub_id      = module.vhub[0].id
  scale_unit          = 1
  tags                = local.common_tags
}

# =============================================================================
# PHASE 3: VIRTUAL NETWORKS
# =============================================================================

# -----------------------------------------------------------------------------
# Spoke VNets
# -----------------------------------------------------------------------------

module "vnet_spoke1" {
  source = "./modules/vnet"

  name                = "vnet-spoke1-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.spoke1_address_space
  subnets             = local.spoke1_subnets
  tags                = local.common_tags
}

module "vnet_spoke2" {
  source = "./modules/vnet"

  name                = "vnet-spoke2-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.spoke2_address_space
  subnets             = local.spoke2_subnets
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# OnPrem VNet (Simulated)
# -----------------------------------------------------------------------------

module "vnet_onprem" {
  source = "./modules/vnet"

  name                = "vnet-onprem-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.onprem_address_space
  subnets             = local.onprem_subnets
  tags                = local.common_tags
}

# =============================================================================
# PHASE 4: NETWORK SECURITY GROUPS (Before any VMs)
# =============================================================================

module "nsg_spoke1" {
  source = "./modules/nsg"

  name                = "nsg-spoke1-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_associations = {
    "Workload"  = module.vnet_spoke1.subnet_ids["Workload"]
    "NvaSubnet" = module.vnet_spoke1.subnet_ids["NvaSubnet"]
  }
  security_rules      = local.default_nsg_rules
  tags                = local.common_tags
}

module "nsg_spoke2" {
  source = "./modules/nsg"

  name                = "nsg-spoke2-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_associations = {
    "Workload" = module.vnet_spoke2.subnet_ids["Workload"]
  }
  security_rules      = local.default_nsg_rules
  tags                = local.common_tags
}

module "nsg_onprem" {
  source = "./modules/nsg"

  name                = "nsg-onprem-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_associations = {
    "Default"   = module.vnet_onprem.subnet_ids["Default"]
    "NvaSubnet" = module.vnet_onprem.subnet_ids["NvaSubnet"]
  }
  security_rules      = local.onprem_nsg_rules
  tags                = local.common_tags
}

# =============================================================================
# PHASE 5: VHUB CONNECTIONS (Spoke VNets to vHub)
# =============================================================================

# Note: Spoke1 cannot connect to vHub when Route Server is deployed
# A VNet cannot have both a local gateway (Route Server) AND use remote gateways (vHub)
module "vhub_connection_spoke1" {
  count  = var.deploy.vwan && !var.deploy.route_server ? 1 : 0  # Disable when Route Server is deployed
  source = "./modules/vhub-connection"

  name                      = "conn-spoke1-${local.name_prefix}"
  virtual_hub_id            = module.vhub[0].id
  remote_virtual_network_id = module.vnet_spoke1.id
  internet_security_enabled = true

  depends_on = [module.vhub_firewall]
}

module "vhub_connection_spoke2" {
  count  = var.deploy.vwan ? 1 : 0
  source = "./modules/vhub-connection"

  name                      = "conn-spoke2-${local.name_prefix}"
  virtual_hub_id            = module.vhub[0].id
  remote_virtual_network_id = module.vnet_spoke2.id
  internet_security_enabled = true

  depends_on = [module.vhub_firewall]
}

# =============================================================================
# PHASE 6: VPN INFRASTRUCTURE
# =============================================================================

# -----------------------------------------------------------------------------
# OnPrem VPN Gateway - Takes ~30 mins
# -----------------------------------------------------------------------------

module "vpn_gateway_onprem" {
  count  = var.deploy.vpn ? 1 : 0
  source = "./modules/vpn-gateway"

  name                = "vpngw-onprem-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  gateway_subnet_id   = module.vnet_onprem.subnet_ids["GatewaySubnet"]
  sku                 = "VpnGw1"
  enable_bgp          = true
  bgp_asn             = 65510
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# VPN Site (represents OnPrem in vWAN)
# -----------------------------------------------------------------------------

module "vpn_site_onprem" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/vpn-site"

  name                = "site-onprem-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_wan_id      = module.vwan[0].id
  vpn_gateway_id      = module.vhub_vpn_gateway[0].id
  address_cidrs       = var.onprem_address_space
  vpn_device_ip       = module.vpn_gateway_onprem[0].public_ip_address
  shared_key          = var.vpn_shared_key
  bgp_enabled         = true
  bgp_asn             = 65510
  bgp_peering_address = module.vpn_gateway_onprem[0].bgp_peering_address
  tags                = local.common_tags

  depends_on = [module.vpn_gateway_onprem, module.vhub_vpn_gateway]
}

# -----------------------------------------------------------------------------
# Local Network Gateway (for OnPrem to vHub connection)
# -----------------------------------------------------------------------------

# Get the vHub VPN Gateway BGP peering address
data "azurerm_vpn_gateway" "vhub" {
  count               = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  name                = module.vhub_vpn_gateway[0].name
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [module.vhub_vpn_gateway]
}

module "local_network_gateway_vhub" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/local-network-gateway"

  name                = "lng-vhub-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  gateway_address     = data.azurerm_vpn_gateway.vhub[0].bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips[0]
  address_space       = ["10.0.0.0/8"]
  bgp_enabled         = true
  bgp_asn             = 65515
  bgp_peering_address = data.azurerm_vpn_gateway.vhub[0].bgp_settings[0].instance_0_bgp_peering_address[0].default_ips[0]
  tags                = local.common_tags

  depends_on = [module.vhub_vpn_gateway]
}

# -----------------------------------------------------------------------------
# VPN Connection (OnPrem GW to Local Network Gateway)
# -----------------------------------------------------------------------------

module "vpn_connection_onprem_to_vhub" {
  count  = var.deploy.vwan && var.deploy.vpn ? 1 : 0
  source = "./modules/vpn-connection"

  name                       = "conn-onprem-to-vhub-${local.name_prefix}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  virtual_network_gateway_id = module.vpn_gateway_onprem[0].id
  local_network_gateway_id   = module.local_network_gateway_vhub[0].id
  shared_key                 = var.vpn_shared_key
  enable_bgp                 = true
  tags                       = local.common_tags

  depends_on = [
    module.vpn_gateway_onprem,
    module.local_network_gateway_vhub,
    module.vpn_site_onprem
  ]
}

# =============================================================================
# PHASE 7: ROUTE SERVER (Optional)
# =============================================================================

module "route_server" {
  count  = var.deploy.route_server ? 1 : 0
  source = "./modules/route-server"

  name                             = "rs-${local.name_prefix}"
  resource_group_name              = azurerm_resource_group.this.name
  location                         = azurerm_resource_group.this.location
  subnet_id                        = module.vnet_spoke1.subnet_ids["RouteServerSubnet"]
  branch_to_branch_traffic_enabled = true
  
  # BGP connection to NVA
  bgp_connections = {
    "spoke1-nva" = {
      name     = "bgp-spoke1-nva"
      peer_ip  = "10.1.8.10"
      peer_asn = 65501
    }
  }

  tags = local.common_tags
}

# =============================================================================
# PHASE 8: DNS
# =============================================================================

# -----------------------------------------------------------------------------
# Private DNS Zones
# -----------------------------------------------------------------------------

module "private_dns_zone_internal" {
  count  = var.deploy.private_dns_zones ? 1 : 0
  source = "./modules/private-dns-zone"

  name                = "lab.internal"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_links = {
    "spoke1" = module.vnet_spoke1.id
    "spoke2" = module.vnet_spoke2.id
    "onprem" = module.vnet_onprem.id
  }
  registration_enabled = true
  tags                 = local.common_tags
}

module "private_dns_zone_blob" {
  count  = var.deploy.private_dns_zones ? 1 : 0
  source = "./modules/private-dns-zone"

  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_links = {
    "spoke1" = module.vnet_spoke1.id
    "spoke2" = module.vnet_spoke2.id
    "onprem" = module.vnet_onprem.id
  }
  registration_enabled = false
  tags                 = local.common_tags
}

# -----------------------------------------------------------------------------
# DNS Private Resolver (Optional)
# -----------------------------------------------------------------------------

module "dns_resolver" {
  count  = var.deploy.dns_resolver ? 1 : 0
  source = "./modules/dns-private-resolver"

  name                = "dnspr-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_network_id  = module.vnet_spoke1.id
  inbound_subnet_id   = module.vnet_spoke1.subnet_ids["DnsResolverInbound"]
  outbound_subnet_id  = module.vnet_spoke1.subnet_ids["DnsResolverOutbound"]
  tags                = local.common_tags
}

# =============================================================================
# PHASE 9: COMPUTE SUPPORT SERVICES
# =============================================================================

# -----------------------------------------------------------------------------
# Internal Load Balancer
# -----------------------------------------------------------------------------

module "load_balancer" {
  count  = var.deploy.load_balancer ? 1 : 0
  source = "./modules/load-balancer"

  name                = "ilb-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet_spoke1.subnet_ids["LoadBalancerSubnet"]
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# Application Gateway (Optional)
# -----------------------------------------------------------------------------

module "application_gateway" {
  count  = var.deploy.application_gateway ? 1 : 0
  source = "./modules/application-gateway"

  name                = "appgw-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet_spoke1.subnet_ids["AppGwSubnet"]
  sku_name            = "WAF_v2"
  sku_tier            = "WAF_v2"
  capacity            = 1
  waf_enabled         = true
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# NAT Gateway (Optional)
# -----------------------------------------------------------------------------

module "nat_gateway" {
  count  = var.deploy.nat_gateway ? 1 : 0
  source = "./modules/nat-gateway"

  name                = "nat-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_associations = {
    "Workload" = module.vnet_spoke1.subnet_ids["Workload"]
  }
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# Azure Bastion (Optional)
# -----------------------------------------------------------------------------

module "bastion" {
  count  = var.deploy.bastion ? 1 : 0
  source = "./modules/bastion"

  name                = "bas-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet_spoke1.subnet_ids["AzureBastionSubnet"]
  sku                 = "Basic"
  tags                = local.common_tags
}

# =============================================================================
# PHASE 10: PRIVATE ENDPOINTS
# =============================================================================

# -----------------------------------------------------------------------------
# Storage Account (for Private Endpoint demo)
# -----------------------------------------------------------------------------

module "storage_account" {
  count  = var.deploy.private_endpoint ? 1 : 0
  source = "./modules/storage-account"

  name_prefix                   = "st${var.project_name}"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  public_network_access_enabled = false
  tags                          = local.common_tags
}

# -----------------------------------------------------------------------------
# Private Endpoint for Storage
# -----------------------------------------------------------------------------

module "private_endpoint_storage" {
  count  = var.deploy.private_endpoint && var.deploy.private_dns_zones ? 1 : 0
  source = "./modules/private-endpoint"

  name                           = "pe-storage-${local.name_prefix}"
  resource_group_name            = azurerm_resource_group.this.name
  location                       = azurerm_resource_group.this.location
  subnet_id                      = module.vnet_spoke1.subnet_ids["PrivateEndpointSubnet"]
  private_connection_resource_id = module.storage_account[0].id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [module.private_dns_zone_blob[0].id]
  tags                           = local.common_tags
}

# =============================================================================
# PHASE 11: VIRTUAL MACHINES
# =============================================================================

# -----------------------------------------------------------------------------
# Spoke1 VMs (with Load Balancer)
# -----------------------------------------------------------------------------

module "vm_spoke1_1" {
  count  = var.deploy.spoke1_vms ? 1 : 0
  source = "./modules/vm-windows"

  name                 = "vm-spoke1-1"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  subnet_id            = module.vnet_spoke1.subnet_ids["Workload"]
  size                 = var.vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  join_lb_backend_pool = var.deploy.load_balancer
  lb_backend_pool_id   = var.deploy.load_balancer ? module.load_balancer[0].backend_pool_id : null
  tags                 = local.common_tags

  depends_on = [module.nsg_spoke1]
}

module "vm_spoke1_2" {
  count  = var.deploy.spoke1_vms ? 1 : 0
  source = "./modules/vm-windows"

  name                 = "vm-spoke1-2"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  subnet_id            = module.vnet_spoke1.subnet_ids["Workload"]
  size                 = var.vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  join_lb_backend_pool = var.deploy.load_balancer
  lb_backend_pool_id   = var.deploy.load_balancer ? module.load_balancer[0].backend_pool_id : null
  tags                 = local.common_tags

  depends_on = [module.nsg_spoke1]
}

# -----------------------------------------------------------------------------
# Spoke2 VM
# -----------------------------------------------------------------------------

module "vm_spoke2_1" {
  count  = var.deploy.spoke2_vms ? 1 : 0
  source = "./modules/vm-windows"

  name                = "vm-spoke2-1"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet_spoke2.subnet_ids["Workload"]
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = local.common_tags

  depends_on = [module.nsg_spoke2]
}

# -----------------------------------------------------------------------------
# OnPrem VM
# -----------------------------------------------------------------------------

module "vm_onprem_1" {
  count  = var.deploy.onprem_vms ? 1 : 0
  source = "./modules/vm-windows"

  name                = "vm-onprem-1"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet_onprem.subnet_ids["Default"]
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = local.common_tags

  depends_on = [module.nsg_onprem]
}

# =============================================================================
# PHASE 12: NETWORK VIRTUAL APPLIANCES
# =============================================================================

# -----------------------------------------------------------------------------
# OnPrem NVA (RRAS for routing)
# -----------------------------------------------------------------------------

module "vm_onprem_nva" {
  count  = var.deploy.nvas ? 1 : 0
  source = "./modules/vm-windows-nva"

  name                = "vm-onprem-nva"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet_onprem.subnet_ids["NvaSubnet"]
  private_ip_address  = "192.168.2.10"
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = local.common_tags

  depends_on = [module.nsg_onprem]
}

# -----------------------------------------------------------------------------
# Spoke1 NVA (for Route Server BGP peering)
# -----------------------------------------------------------------------------

module "vm_spoke1_nva" {
  count  = var.deploy.nvas ? 1 : 0
  source = "./modules/vm-windows-nva"

  name                = "vm-spoke1-nva"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet_spoke1.subnet_ids["NvaSubnet"]
  private_ip_address  = "10.1.8.10"
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  
  # BGP configuration for Route Server peering
  bgp_asn           = var.deploy.route_server ? 65501 : null
  route_server_ips  = var.deploy.route_server ? module.route_server[0].virtual_router_ips : []
  advertised_routes = var.deploy.route_server ? ["10.100.0.0/16"] : []  # Example route to advertise
  
  tags = local.common_tags

  depends_on = [module.nsg_spoke1, module.route_server]
}
