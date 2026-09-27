resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.ctx.tags
}
resource "azurerm_web_application_firewall_policy" "this" {
  count               = var.waf_enabled ? 1 : 0
  name                = "${var.name}-waf"
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  policy_settings {
    enabled            = true
    mode               = var.waf_mode
    request_body_check = true
  }
  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
  tags = var.ctx.tags
}
resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
  firewall_policy_id  = var.waf_enabled ? azurerm_web_application_firewall_policy.this[0].id : null
  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.autoscale_min == null ? var.capacity : null
  }
  dynamic "autoscale_configuration" {
    for_each = var.autoscale_min == null ? [] : [1]
    content {
      min_capacity = var.autoscale_min
      max_capacity = var.autoscale_max
    }
  }
  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }
  frontend_ip_configuration {
    name                 = "frontend-public"
    public_ip_address_id = azurerm_public_ip.this.id
  }
  frontend_port {
    name = "http-port"
    port = 80
  }
  dynamic "frontend_port" {
    for_each = var.certificate_secret_id == null ? [] : [1]
    content {
      name = "https-port"
      port = 443
    }
  }
  backend_address_pool {
    name         = "backend-pool"
    ip_addresses = var.backend_ip_addresses
  }
  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "web-health"
  }
  probe {
    name                = "web-health"
    protocol            = "Http"
    host                = "127.0.0.1"
    path                = "/health.html"
    interval            = 30
    timeout             = 10
    unhealthy_threshold = 3
    match { status_code = ["200-399"] }
  }
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-public"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_name                      = var.host_name
  }
  request_routing_rule {
    name                        = "http-rule"
    priority                    = 100
    rule_type                   = "Basic"
    http_listener_name          = "http-listener"
    backend_address_pool_name   = var.certificate_secret_id == null ? "backend-pool" : null
    backend_http_settings_name  = var.certificate_secret_id == null ? "http-settings" : null
    redirect_configuration_name = var.certificate_secret_id == null ? null : "redirect-to-https"
  }
  dynamic "identity" {
    for_each = var.certificate_secret_id == null ? [] : [1]
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }
  dynamic "ssl_certificate" {
    for_each = var.certificate_secret_id == null ? [] : [1]
    content {
      name                = "existing-key-vault-certificate"
      key_vault_secret_id = var.certificate_secret_id
    }
  }
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101S"
  }
  dynamic "http_listener" {
    for_each = var.certificate_secret_id == null ? [] : [1]
    content {
      name                           = "https-listener"
      frontend_ip_configuration_name = "frontend-public"
      frontend_port_name             = "https-port"
      protocol                       = "Https"
      ssl_certificate_name           = "existing-key-vault-certificate"
      host_name                      = var.host_name
      require_sni                    = true
    }
  }
  dynamic "redirect_configuration" {
    for_each = var.certificate_secret_id == null ? [] : [1]
    content {
      name                 = "redirect-to-https"
      redirect_type        = "Permanent"
      target_listener_name = "https-listener"
      include_path         = true
      include_query_string = true
    }
  }
  dynamic "request_routing_rule" {
    for_each = var.certificate_secret_id == null ? [] : [1]
    content {
      name                       = "https-rule"
      priority                   = 110
      rule_type                  = "Basic"
      http_listener_name         = "https-listener"
      backend_address_pool_name  = "backend-pool"
      backend_http_settings_name = "http-settings"
    }
  }
  tags = var.ctx.tags
}
