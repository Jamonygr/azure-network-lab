resource "azurerm_firewall_policy" "this" {
  name                = var.policy_name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  sku                 = "Standard"

  threat_intelligence_mode = "Deny"

  dns {
    proxy_enabled = true
  }

  tags = var.ctx.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "DefaultRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 100

  network_rule_collection {
    name     = "AllowLabNetworks"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "LabWebAndRdp"
      protocols             = ["TCP"]
      source_addresses      = var.source_cidrs
      destination_addresses = var.source_cidrs
      destination_ports     = ["80", "443", "3389"]
    }
    rule {
      name              = "WindowsActivation"
      protocols         = ["TCP"]
      source_addresses  = var.source_cidrs
      destination_fqdns = ["azkms.core.windows.net", "kms.core.windows.net"]
      destination_ports = ["1688"]
    }
    rule {
      name                  = "LabDns"
      protocols             = ["TCP", "UDP"]
      source_addresses      = var.source_cidrs
      destination_addresses = var.source_cidrs
      destination_ports     = ["53"]
    }
    rule {
      name                  = "LabIcmp"
      protocols             = ["ICMP"]
      source_addresses      = var.source_cidrs
      destination_addresses = var.source_cidrs
      destination_ports     = ["*"]
    }
  }
  dynamic "network_rule_collection" {
    for_each = var.enable_monitoring_egress ? [1] : []
    content {
      name     = "AzureMonitorAgent"
      priority = 150
      action   = "Allow"
      rule {
        name                  = "MonitorHttps"
        protocols             = ["TCP"]
        source_addresses      = var.source_cidrs
        destination_addresses = ["AzureMonitor"]
        destination_ports     = ["443"]
      }
    }
  }
  application_rule_collection {
    name     = "ApprovedHttps"
    priority = 200
    action   = "Allow"
    rule {
      name = "LearningDestinations"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = var.source_cidrs
      destination_fqdns = var.allowed_fqdns
    }
    rule {
      name = "WindowsUpdate"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = var.source_cidrs
      destination_fqdn_tags = ["WindowsUpdate"]
    }
  }
}

resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.ctx.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id

  virtual_hub {
    virtual_hub_id  = var.virtual_hub_id
    public_ip_count = 1
  }

  tags = var.ctx.tags
}

resource "azurerm_virtual_hub_routing_intent" "this" {
  name           = "RoutingIntent"
  virtual_hub_id = var.virtual_hub_id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.this.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.this.id
  }

  depends_on = [azurerm_firewall.this]
}
