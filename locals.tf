locals {
  // Naming prefix for single lab environment.
  prefix = lower(var.ctx.project)

  // Tag guardrails.
  required_tag_keys = ["Environment", "Project", "ManagedBy", "Purpose"]
  default_tags = {
    ManagedBy = "Terraform"
    Purpose   = "AZ-700 Networking Lab"
  }

  // =============================================================================
  // Spoke1 Subnets
  // =============================================================================
  spoke1_subnets = {
    "Workload" = {
      address_prefix    = "10.1.1.0/24"
      service_endpoints = []
      delegation        = null
    }
    "AppGwSubnet" = {
      address_prefix    = "10.1.2.0/24"
      service_endpoints = []
      delegation        = null
    }
    "AzureBastionSubnet" = {
      address_prefix    = "10.1.3.0/26"
      service_endpoints = []
      delegation        = null
    }
    "PrivateEndpointSubnet" = {
      address_prefix                    = "10.1.4.0/24"
      service_endpoints                 = []
      delegation                        = null
      private_endpoint_network_policies = "Disabled"
    }
    "DnsResolverInbound" = {
      address_prefix    = "10.1.5.0/28"
      service_endpoints = []
      delegation = {
        name         = "dns-resolver-delegation"
        service_name = "Microsoft.Network/dnsResolvers"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
    "DnsResolverOutbound" = {
      address_prefix    = "10.1.5.16/28"
      service_endpoints = []
      delegation = {
        name         = "dns-resolver-delegation"
        service_name = "Microsoft.Network/dnsResolvers"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
    "LoadBalancerSubnet" = {
      address_prefix    = "10.1.6.0/24"
      service_endpoints = []
      delegation        = null
    }
    "RouteServerSubnet" = {
      address_prefix    = "10.1.7.0/27"
      service_endpoints = []
      delegation        = null
    }
    "NvaSubnet" = {
      address_prefix    = "10.1.8.0/24"
      service_endpoints = []
      delegation        = null
    }
  }

  // =============================================================================
  // Spoke2 Subnets
  // =============================================================================
  spoke2_subnets = {
    "Workload" = {
      address_prefix    = "10.2.1.0/24"
      service_endpoints = ["Microsoft.Storage"]
      delegation        = null
    }
  }

  // =============================================================================
  // OnPrem Subnets
  // =============================================================================
  onprem_subnets = {
    "GatewaySubnet" = {
      address_prefix    = "192.168.0.0/27"
      service_endpoints = []
      delegation        = null
    }
    "Default" = {
      address_prefix    = "192.168.1.0/24"
      service_endpoints = []
      delegation        = null
    }
    "NvaSubnet" = {
      address_prefix    = "192.168.2.0/24"
      service_endpoints = []
      delegation        = null
    }
  }

  // =============================================================================
  // NSG Rules
  // =============================================================================
  default_nsg_rules = {
    "AllowRDP" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
    }
    "AllowICMP" = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    "AllowHTTP" = {
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    "AllowHTTPS" = {
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  onprem_nsg_rules = merge(local.default_nsg_rules, {
    "AllowRDPFromInternet" = {
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "192.168.0.0/16"
      destination_address_prefix = "*"
    }
  })

  // =============================================================================
  // Data-driven maps for for_each
  // =============================================================================
  vnets = {
    spoke1 = {
      name          = "vnet-spoke1-${local.prefix}"
      address_space = var.spoke1_address_space
      subnets       = local.spoke1_subnets
    }
    spoke2 = {
      name          = "vnet-spoke2-${local.prefix}"
      address_space = var.spoke2_address_space
      subnets       = local.spoke2_subnets
    }
    onprem = {
      name          = "vnet-onprem-${local.prefix}"
      address_space = var.onprem_address_space
      subnets       = local.onprem_subnets
    }
  }

  nsgs = {
    spoke1 = {
      name         = "nsg-spoke1-${local.prefix}"
      vnet_key     = "spoke1"
      subnet_names = ["Workload", "NvaSubnet"]
      rules        = local.default_nsg_rules
    }
    spoke2 = {
      name         = "nsg-spoke2-${local.prefix}"
      vnet_key     = "spoke2"
      subnet_names = ["Workload"]
      rules        = local.default_nsg_rules
    }
    onprem = {
      name         = "nsg-onprem-${local.prefix}"
      vnet_key     = "onprem"
      subnet_names = ["Default", "NvaSubnet"]
      rules        = local.onprem_nsg_rules
    }
  }

  vnet_peerings = {
    spoke1_to_spoke2 = {
      name                         = "peer-spoke1-to-spoke2"
      vnet_key                     = "spoke1"
      remote_vnet_key              = "spoke2"
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
    spoke2_to_spoke1 = {
      name                         = "peer-spoke2-to-spoke1"
      vnet_key                     = "spoke2"
      remote_vnet_key              = "spoke1"
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  }

  vhub_connections = {
    spoke1 = {
      name                      = "conn-spoke1-${local.prefix}"
      vnet_key                  = "spoke1"
      internet_security_enabled = true
      enabled                   = var.deploy.vwan && !var.deploy.route_server
    }
    spoke2 = {
      name                      = "conn-spoke2-${local.prefix}"
      vnet_key                  = "spoke2"
      internet_security_enabled = true
      enabled                   = var.deploy.vwan
    }
  }

  private_dns_zones = {
    internal = {
      name                 = "lab.internal"
      registration_enabled = true
    }
    blob = {
      name                 = "privatelink.blob.core.windows.net"
      registration_enabled = false
    }
  }

  vm_windows = {
    "spoke1-1" = {
      name                  = "vm-spoke1-1"
      vnet_key              = "spoke1"
      subnet_name           = "Workload"
      join_lb_backend_pool  = var.deploy.load_balancer
      enabled               = var.deploy.spoke1_vms
    }
    "spoke1-2" = {
      name                  = "vm-spoke1-2"
      vnet_key              = "spoke1"
      subnet_name           = "Workload"
      join_lb_backend_pool  = var.deploy.load_balancer
      enabled               = var.deploy.spoke1_vms
    }
    "spoke2-1" = {
      name                  = "vm-spoke2-1"
      vnet_key              = "spoke2"
      subnet_name           = "Workload"
      join_lb_backend_pool  = false
      enabled               = var.deploy.spoke2_vms
    }
    "onprem-1" = {
      name                  = "vm-onprem-1"
      vnet_key              = "onprem"
      subnet_name           = "Default"
      join_lb_backend_pool  = false
      enabled               = var.deploy.onprem_vms
    }
  }

  vm_nva = {
    onprem = {
      name              = "vm-onprem-nva"
      vnet_key          = "onprem"
      subnet_name       = "NvaSubnet"
      private_ip        = "192.168.2.10"
      bgp_asn           = null
      advertised_routes = []
    }
    spoke1 = {
      name              = "vm-spoke1-nva"
      vnet_key          = "spoke1"
      subnet_name       = "NvaSubnet"
      private_ip        = "10.1.8.10"
      bgp_asn           = var.deploy.route_server ? 65501 : null
      advertised_routes = var.deploy.route_server ? ["10.100.0.0/16"] : []
    }
  }

  route_server_bgp_connections = {
    "spoke1-nva" = {
      peer_ip  = "10.1.8.10"
      peer_asn = 65501
    }
  }

  vnet_link_keys = ["spoke1", "spoke2", "onprem"]

  // Filtered maps for for_each.
  vhub_connections_enabled   = { for k, v in local.vhub_connections : k => v if v.enabled }
  private_dns_zones_enabled  = var.deploy.private_dns_zones ? local.private_dns_zones : {}
  vm_windows_enabled         = { for k, v in local.vm_windows : k => v if v.enabled }
  vm_nva_enabled             = var.deploy.nvas ? local.vm_nva : {}
  vnet_peerings_enabled      = var.deploy.route_server ? local.vnet_peerings : {}

  // Derived values.
  ctx = {
    project  = var.ctx.project
    location = var.ctx.location
    tags     = module.tags.tags
  }

  project_tag                 = try(module.tags.tags["Project"], "")
  storage_account_name_prefix = "st${lower(replace(local.project_tag, "-", ""))}"
  vwan_id                      = try(module.vwan[0].id, null)
  vhub_id                      = try(module.vhub[0].id, null)
  vhub_bgp_settings            = try(module.vhub_vpn_gateway[0].bgp_settings, [])
  vhub_bgp_instance0           = try(local.vhub_bgp_settings[0].instance_0_bgp_peering_address[0], null)
  vhub_gateway_tunnel_ip  = try(local.vhub_bgp_instance0.tunnel_ips[0], null)
  vhub_gateway_default_ip = try(local.vhub_bgp_instance0.default_ips[0], null)
}
