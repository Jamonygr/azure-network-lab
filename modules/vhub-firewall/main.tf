resource "azurerm_firewall_policy" "this" {
  name                = var.policy_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  threat_intelligence_mode = "Alert"

  dns {
    proxy_enabled = true
  }

  tags = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "DefaultRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 100

  network_rule_collection {
    name     = "AllowNetworkRules"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "AllowAllOutbound"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["10.0.0.0/8", "192.168.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }

    rule {
      name                  = "AllowICMP"
      protocols             = ["ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }

  application_rule_collection {
    name     = "AllowWebTraffic"
    priority = 200
    action   = "Allow"

    rule {
      name = "AllowHTTPS"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.0/8", "192.168.0.0/16"]
      destination_fqdns = ["*"]
    }

    rule {
      name = "AllowHTTP"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = ["10.0.0.0/8", "192.168.0.0/16"]
      destination_fqdns = ["*"]
    }
  }
}

resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id

  virtual_hub {
    virtual_hub_id  = var.virtual_hub_id
    public_ip_count = 1
  }

  tags = var.tags
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
