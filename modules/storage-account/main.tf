resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Public data access is disabled and all trusted-service bypass is intentionally denied.
# Opening AzureServices solely to satisfy AZU-0010 would weaken this private-only sample.
#trivy:ignore:AVD-AZU-0010
resource "azurerm_storage_account" "this" {
  name                     = "${var.name_prefix}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.ctx.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  public_network_access_enabled   = var.public_network_access_enabled
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
  default_to_oauth_authentication = true

  network_rules {
    default_action = "Deny"
    bypass         = []
  }

  tags = var.ctx.tags

  lifecycle {
    precondition {
      condition     = var.public_network_access_enabled ? var.allow_public_network_access : true
      error_message = "Public network access must be explicitly allowed via allow_public_network_access."
    }
  }
}
