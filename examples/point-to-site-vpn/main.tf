locals {
  scenario = "point-to-site-vpn"
  tags     = { lab_id = var.lab_id, environment = "lab", managed_by = "terraform", scenario = local.scenario }
}
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.lab_id}-p2s"
  location = var.location
  tags     = local.tags
  lifecycle {
    precondition {
      condition     = var.enable_paid_features
      error_message = "Billable example disabled. Review costs and explicitly enable_paid_features."
    }
  }
}
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-${var.lab_id}-p2s"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.88.0.0/16"]
  tags                = local.tags
}
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.88.0.0/27"]
}
resource "azurerm_subnet" "target" {
  name                            = "target"
  resource_group_name             = azurerm_resource_group.lab.name
  virtual_network_name            = azurerm_virtual_network.lab.name
  address_prefixes                = ["10.88.1.0/24"]
  default_outbound_access_enabled = false
}
resource "azurerm_public_ip" "gateway" {
  name                = "pip-${var.lab_id}-vpn"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = local.tags
}
resource "azurerm_virtual_network_gateway" "lab" {
  name                = "vpngw-${var.lab_id}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1AZ"
  generation          = "Generation1"
  active_active       = false
  enable_bgp          = false
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.gateway.id
    public_ip_address_id          = azurerm_public_ip.gateway.id
    private_ip_address_allocation = "Dynamic"
  }
  vpn_client_configuration {
    address_space        = [var.vpn_client_address_pool]
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
    aad_audience         = var.vpn_aad_audience
    aad_tenant           = var.vpn_aad_tenant_url
    aad_issuer           = var.vpn_aad_issuer_url
  }
  tags = local.tags
}
resource "azurerm_network_security_group" "target" {
  name                = "nsg-${var.lab_id}-p2s-target"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  security_rule {
    name                       = "AllowVPNClientHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.vpn_client_address_pool
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyOtherInbound"
    priority                   = 4000
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
resource "azurerm_network_interface" "target" {
  name                = "nic-${var.lab_id}-target"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.target.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.88.1.10"

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
  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))

  boot_diagnostics {}
  tags = local.tags
}
