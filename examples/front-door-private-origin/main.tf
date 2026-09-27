locals {
  scenario = "front-door-private-origin"
  suffix   = substr(sha256("${var.subscription_id}-${var.lab_id}-${local.scenario}"), 0, 8)
  tags     = { lab_id = var.lab_id, environment = "lab", managed_by = "terraform", scenario = local.scenario }
}
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.lab_id}-afd"
  location = var.location
  tags     = local.tags
  lifecycle {
    precondition {
      condition     = var.enable_paid_features
      error_message = "Billable example disabled. Review costs and explicitly enable_paid_features."
    }
  }
}
resource "azurerm_service_plan" "origin" {
  name                = "asp-${var.lab_id}-afd"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  os_type             = "Linux"
  sku_name            = "P0v3"
  tags                = local.tags
}
resource "azurerm_linux_web_app" "origin" {
  name                                           = "app-${var.lab_id}-${local.suffix}"
  location                                       = var.location
  resource_group_name                            = azurerm_resource_group.lab.name
  service_plan_id                                = azurerm_service_plan.origin.id
  https_only                                     = true
  public_network_access_enabled                  = false
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false
  site_config {
    always_on           = true
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    application_stack { node_version = "22-lts" }
    app_command_line = "node -e \"require('http').createServer((q,s)=>{s.writeHead(200,{'Content-Type':'text/plain'});s.end('private-origin-${var.lab_id}');}).listen(process.env.PORT||8080,'0.0.0.0')\""
  }
  tags = local.tags
}
resource "azurerm_cdn_frontdoor_profile" "lab" {
  name                = "afd-${var.lab_id}-${local.suffix}"
  resource_group_name = azurerm_resource_group.lab.name
  sku_name            = "Premium_AzureFrontDoor"
  tags                = local.tags
}
resource "azurerm_cdn_frontdoor_endpoint" "lab" {
  name                     = "edge-${var.lab_id}-${local.suffix}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.lab.id
  tags                     = local.tags
}
resource "azurerm_cdn_frontdoor_origin_group" "lab" {
  name                     = "private-app"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.lab.id
  load_balancing {}
  health_probe {
    interval_in_seconds = 30
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }
}
resource "azurerm_cdn_frontdoor_origin" "lab" {
  name                           = "private-app"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.lab.id
  host_name                      = azurerm_linux_web_app.origin.default_hostname
  origin_host_header             = azurerm_linux_web_app.origin.default_hostname
  certificate_name_check_enabled = true
  enabled                        = true
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
  private_link {
    location               = var.location
    private_link_target_id = azurerm_linux_web_app.origin.id
    target_type            = "sites"
    request_message        = "Approve only the Front Door origin belonging to this disposable lab."
  }
}
resource "azurerm_cdn_frontdoor_route" "lab" {
  name                          = "https-origin"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.lab.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.lab.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.lab.id]
  forwarding_protocol           = "HttpsOnly"
  https_redirect_enabled        = true
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  link_to_default_domain        = true
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.lab.id]
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress     = ["text/plain"]
  }
  depends_on = [azurerm_cdn_frontdoor_rule.lab]
}
resource "azurerm_cdn_frontdoor_firewall_policy" "lab" {
  name                = "waf${var.lab_id}"
  resource_group_name = azurerm_resource_group.lab.name
  sku_name            = "Premium_AzureFrontDoor"
  enabled             = true
  mode                = "Prevention"
  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }
  custom_rule {
    name     = "BlockLabTestHeader"
    enabled  = true
    priority = 10
    type     = "MatchRule"
    action   = "Block"
    match_condition {
      match_variable = "RequestHeader"
      selector       = "X-Lab-Block"
      operator       = "Equal"
      match_values   = ["true"]
    }
  }
  tags = local.tags
}
resource "azurerm_cdn_frontdoor_security_policy" "lab" {
  name                     = "attach-waf"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.lab.id
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.lab.id
      association {
        patterns_to_match = ["/*"]
        domain { cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.lab.id }
      }
    }
  }
}


resource "azurerm_cdn_frontdoor_rule_set" "lab" {
  name                     = "LabResponse"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.lab.id
}
resource "azurerm_cdn_frontdoor_rule" "lab" {
  name                      = "CacheDemo"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.lab.id
  order                     = 1
  behavior_on_match         = "Continue"
  actions {
    response_header_action {
      header_action = "Overwrite"
      header_name   = "X-Lab-Rule"
      value         = "cache-demo"
    }
    route_configuration_override_action {
      cache_behavior                = "OverrideAlways"
      cache_duration                = "00:01:00"
      compression_enabled           = true
      query_string_caching_behavior = "IgnoreQueryString"
    }
  }
}
