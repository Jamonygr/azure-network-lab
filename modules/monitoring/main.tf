data "azurerm_network_watcher" "existing" {
  count               = var.flow_logs || var.connection_monitor ? 1 : 0
  name                = var.network_watcher.name
  resource_group_name = var.network_watcher.resource_group_name
  lifecycle {
    postcondition {
      condition     = lower(replace(self.location, " ", "")) == var.ctx.location
      error_message = "The existing Network Watcher must be in the same region as the lab."
    }
  }
}
resource "random_string" "suffix" {
  count   = var.flow_logs ? 1 : 0
  length  = 8
  special = false
  upper   = false
}
# Flow logs use service-managed storage writes and shared-key authorization.
# The data endpoint is deny-by-default, with trusted Azure services permitted.
# This storage has different requirements from the private-endpoint sample.
resource "azurerm_storage_account" "flow" {
  count                           = var.flow_logs ? 1 : 0
  name                            = "flow${substr(replace(var.name, "-", ""), 0, 12)}${random_string.suffix[0].result}"
  resource_group_name             = var.resource_group_name
  location                        = var.ctx.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
  tags = var.ctx.tags
}
resource "azurerm_network_watcher_flow_log" "vnet" {
  for_each             = var.flow_logs ? var.vnet_ids : {}
  name                 = "flow-${var.name}-${each.key}"
  network_watcher_name = data.azurerm_network_watcher.existing[0].name
  resource_group_name  = data.azurerm_network_watcher.existing[0].resource_group_name
  location             = var.ctx.location
  target_resource_id   = each.value
  storage_account_id   = azurerm_storage_account.flow[0].id
  enabled              = true
  version              = 2
  retention_policy {
    enabled = true
    days    = var.retention_days
  }
  dynamic "traffic_analytics" {
    for_each = var.traffic_analytics ? [1] : []
    content {
      enabled               = true
      workspace_id          = var.workspace_id
      workspace_region      = var.ctx.location
      workspace_resource_id = var.workspace_resource_id
      interval_in_minutes   = 60
    }
  }
  tags = var.ctx.tags
}
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each                   = var.diagnostic_target_ids
  name                       = "diag-${var.name}-${each.key}"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_resource_id
  enabled_log {
    category_group = "allLogs"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}
resource "azurerm_virtual_machine_extension" "network_watcher" {
  count                      = var.connection_monitor ? 1 : 0
  name                       = "network-watcher-agent"
  virtual_machine_id         = var.source_vm_id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  tags                       = var.ctx.tags
}
resource "azurerm_network_connection_monitor" "this" {
  count              = var.connection_monitor ? 1 : 0
  name               = "cm-${var.name}"
  network_watcher_id = data.azurerm_network_watcher.existing[0].id
  location           = var.ctx.location
  endpoint {
    name               = "source"
    target_resource_id = var.source_vm_id
  }
  endpoint {
    name    = "destination"
    address = var.connection_target
  }
  test_configuration {
    name                      = "tcp443"
    protocol                  = "Tcp"
    test_frequency_in_seconds = 60
    tcp_configuration { port = 443 }
  }
  test_group {
    name                     = "approved-egress"
    source_endpoints         = ["source"]
    destination_endpoints    = ["destination"]
    test_configuration_names = ["tcp443"]
  }
  output_workspace_resource_ids = [var.workspace_resource_id]
  tags                          = var.ctx.tags
  depends_on                    = [azurerm_virtual_machine_extension.network_watcher]
}
