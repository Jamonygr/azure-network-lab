locals {
  scenario = "ddos-protection"
  tags     = { lab_id = var.lab_id, environment = "lab", managed_by = "terraform", scenario = local.scenario }
}
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.lab_id}-ddos"
  location = var.location
  tags     = local.tags
  lifecycle {
    precondition {
      condition     = var.enable_paid_features
      error_message = "Billable example disabled. Review costs and explicitly enable_paid_features."
    }
  }
}
resource "azurerm_network_ddos_protection_plan" "lab" {
  name                = "ddos-${var.lab_id}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-${var.lab_id}-ddos"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.89.0.0/16"]
  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.lab.id
    enable = true
  }
  tags = local.tags
}
resource "azurerm_subnet" "target" {
  name                            = "protected"
  resource_group_name             = azurerm_resource_group.lab.name
  virtual_network_name            = azurerm_virtual_network.lab.name
  address_prefixes                = ["10.89.1.0/24"]
  default_outbound_access_enabled = false
}
resource "azurerm_public_ip" "protected" {
  name                 = "pip-${var.lab_id}-protected"
  location             = var.location
  resource_group_name  = azurerm_resource_group.lab.name
  sku                  = "Standard"
  allocation_method    = "Static"
  ddos_protection_mode = "VirtualNetworkInherited"
  tags                 = local.tags
}
resource "azurerm_network_security_group" "target" {
  name                = "nsg-${var.lab_id}-protected"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  security_rule {
    name                       = "DenyInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.tags
}
resource "azurerm_subnet_network_security_group_association" "target" {
  subnet_id                 = azurerm_subnet.target.id
  network_security_group_id = azurerm_network_security_group.target.id
}
resource "azurerm_log_analytics_workspace" "lab" {
  name                = "law-${var.lab_id}-ddos"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}
resource "azurerm_monitor_diagnostic_setting" "ddos" {
  name                       = "ddos-events"
  target_resource_id         = azurerm_public_ip.protected.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab.id
  enabled_log { category = "DDoSProtectionNotifications" }
  enabled_log { category = "DDoSMitigationFlowLogs" }
  enabled_log { category = "DDoSMitigationReports" }
  enabled_metric { category = "AllMetrics" }
}
resource "azurerm_monitor_action_group" "lab" {
  count               = var.alert_email == "" ? 0 : 1
  name                = "ag-${var.lab_id}-ddos"
  resource_group_name = azurerm_resource_group.lab.name
  short_name          = "ddoslab"
  email_receiver {
    name          = "operator"
    email_address = var.alert_email
  }
  tags = local.tags
}
resource "azurerm_monitor_metric_alert" "attack" {
  name                = "ddos-attack-${var.lab_id}"
  resource_group_name = azurerm_resource_group.lab.name
  scopes              = [azurerm_public_ip.protected.id]
  description         = "DDoS mitigation detected on the disposable lab public IP."
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Network/publicIPAddresses"
    metric_name      = "IfUnderDDoSAttack"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = 0
  }
  dynamic "action" {
    for_each = azurerm_monitor_action_group.lab
    content { action_group_id = action.value.id }
  }
  tags = local.tags
}
resource "azurerm_network_interface" "target" {
  name                = "nic-${var.lab_id}-target"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.target.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.89.1.10"
    public_ip_address_id          = azurerm_public_ip.protected.id

  }
  tags = local.tags
}
resource "azurerm_linux_virtual_machine" "target" {
  name                            = "vm-${var.lab_id}-target"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.lab.name
  size                            = "Standard_B1s"
  admin_username                  = "labadmin"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.target.id]
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


  tags = local.tags
}
