locals {
  scenario = "traffic-manager"
  suffix   = substr(sha256("${var.subscription_id}-${var.lab_id}-${local.scenario}"), 0, 8)
  tags     = { lab_id = var.lab_id, environment = "lab", managed_by = "terraform", scenario = local.scenario }
}
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.lab_id}-tm"
  location = var.location
  tags     = local.tags
  lifecycle {
    precondition {
      condition     = var.enable_paid_features
      error_message = "Billable example disabled. Review costs and explicitly enable_paid_features."
    }
  }
}
locals { regions = { primary = var.location, secondary = var.secondary_location } }
resource "azurerm_service_plan" "region" {
  for_each            = local.regions
  name                = "asp-${var.lab_id}-${each.key}"
  location            = each.value
  resource_group_name = azurerm_resource_group.lab.name
  os_type             = "Linux"
  sku_name            = "S1"
  tags                = local.tags
}
resource "azurerm_linux_web_app" "region" {
  for_each                                       = local.regions
  name                                           = "app-${var.lab_id}-${each.key}-${local.suffix}"
  location                                       = each.value
  resource_group_name                            = azurerm_resource_group.lab.name
  service_plan_id                                = azurerm_service_plan.region[each.key].id
  https_only                                     = true
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false
  site_config {
    always_on           = true
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    application_stack { node_version = "22-lts" }
    app_command_line = "node -e \"require('http').createServer((q,s)=>{s.writeHead(200,{'Content-Type':'text/plain'});s.end('${each.key}:${each.value}');}).listen(process.env.PORT||8080,'0.0.0.0')\""
  }
  tags = local.tags
}
resource "azurerm_traffic_manager_profile" "lab" {
  name                   = "tm-${var.lab_id}-${local.suffix}"
  resource_group_name    = azurerm_resource_group.lab.name
  traffic_routing_method = var.routing_method
  dns_config {
    relative_name = "tm-${var.lab_id}-${local.suffix}"
    ttl           = 30
  }
  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }
  tags = local.tags
}
resource "azurerm_traffic_manager_azure_endpoint" "region" {
  for_each             = local.regions
  name                 = each.key
  profile_id           = azurerm_traffic_manager_profile.lab.id
  target_resource_id   = azurerm_linux_web_app.region[each.key].id
  enabled              = true
  always_serve_enabled = false
  priority             = var.routing_method == "Priority" ? (each.key == "primary" ? 1 : 2) : null
  weight               = var.routing_method == "Weighted" ? var.endpoint_weights[each.key] : null
  geo_mappings         = var.routing_method == "Geographic" ? var.geographic_mappings[each.key] : null
}
