locals {
  # Resource naming prefix
  name_prefix = "${var.project_name}-${var.environment}"

  # Common tags
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Purpose     = "AZ-700 Networking Lab"
  })

  # =============================================================================
  # Spoke1 Subnets
  # =============================================================================
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
      address_prefix    = "10.1.4.0/24"
      service_endpoints = []
      delegation        = null
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
      address_prefix    = "10.1.7.0/27"  # Minimum /27 required for Route Server
      service_endpoints = []
      delegation        = null
    }
    "NvaSubnet" = {
      address_prefix    = "10.1.8.0/24"
      service_endpoints = []
      delegation        = null
    }
  }

  # =============================================================================
  # Spoke2 Subnets
  # =============================================================================
  spoke2_subnets = {
    "Workload" = {
      address_prefix    = "10.2.1.0/24"
      service_endpoints = ["Microsoft.Storage"]
      delegation        = null
    }
  }

  # =============================================================================
  # OnPrem Subnets
  # =============================================================================
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

  # =============================================================================
  # NSG Rules
  # =============================================================================
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
}
