locals {
  scenario = "service-endpoint-policy"
  suffix   = substr(sha256("${var.subscription_id}-${var.lab_id}-${local.scenario}"), 0, 8)
  tags     = { lab_id = var.lab_id, environment = "lab", managed_by = "terraform", scenario = local.scenario }
}
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.lab_id}-sep"
  location = var.location
  tags     = local.tags
  lifecycle {
    precondition {
      condition     = var.enable_paid_features
      error_message = "Billable example disabled. Review costs and explicitly enable_paid_features."
    }
  }
}
resource "azurerm_resource_group" "allowed_storage" {
  name       = "rg-${var.lab_id}-sep-allowed"
  location   = var.location
  tags       = local.tags
  depends_on = [azurerm_resource_group.lab]
}
resource "azurerm_subnet_service_endpoint_storage_policy" "lab" {
  name                = "sep-${var.lab_id}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  definition {
    name              = "OnlyOwnedAllowedStorageGroup"
    description       = "Allow Storage only in this dedicated disposable resource group."
    service           = "Microsoft.Storage"
    service_resources = [azurerm_resource_group.allowed_storage.id]
  }
  tags = local.tags
}
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-${var.lab_id}-sep"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.86.0.0/16"]
  tags                = local.tags
}
resource "azurerm_subnet" "client" {
  name                            = "client"
  resource_group_name             = azurerm_resource_group.lab.name
  virtual_network_name            = azurerm_virtual_network.lab.name
  address_prefixes                = ["10.86.1.0/24"]
  service_endpoints               = ["Microsoft.Storage"]
  service_endpoint_policy_ids     = [azurerm_subnet_service_endpoint_storage_policy.lab.id]
  default_outbound_access_enabled = false
}
# Trusted-service bypass would undermine the subnet policy exercise; no integrations require it.
#trivy:ignore:AVD-AZU-0010
resource "azurerm_storage_account" "target" {
  for_each                        = toset(["allowed", "denied"])
  name                            = "st${substr(each.key, 0, 1)}${local.suffix}"
  resource_group_name             = each.key == "allowed" ? azurerm_resource_group.allowed_storage.name : azurerm_resource_group.lab.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = true
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
  network_rules {
    default_action             = "Deny"
    bypass                     = ["None"]
    virtual_network_subnet_ids = [azurerm_subnet.client.id]
  }
  tags = local.tags
}
resource "azurerm_role_assignment" "read_storage" {
  for_each             = azurerm_storage_account.target
  scope                = each.value.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_virtual_machine.client.identity[0].principal_id
}
resource "azurerm_network_interface" "client" {
  name                = "nic-${var.lab_id}-client"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.client.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.86.1.10"

  }
  tags = local.tags
}
resource "azurerm_linux_virtual_machine" "client" {
  name                            = "vm-${var.lab_id}-client"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.lab.name
  size                            = "Standard_B1s"
  admin_username                  = "labadmin"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.client.id]
  admin_ssh_key {
    username   = "labadmin"
    public_key = trimspace(var.ssh_public_key)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity { type = "SystemAssigned" }
  boot_diagnostics {}
  custom_data = base64encode(templatefile("${path.module}/probe-cloud-init.yaml", {
    probe_script_b64 = base64encode(file("${path.module}/probe-storage.sh"))
    probe_arguments  = "${azurerm_storage_account.target["allowed"].name} ${azurerm_storage_account.target["denied"].name}"
  }))
  tags = local.tags
}
