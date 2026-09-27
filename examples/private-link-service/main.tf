locals {
  scenario = "private-link-service"
  tags     = { lab_id = var.lab_id, environment = "lab", managed_by = "terraform", scenario = local.scenario }
}
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.lab_id}-pls"
  location = var.location
  tags     = local.tags
  lifecycle {
    precondition {
      condition     = var.enable_paid_features
      error_message = "Billable example disabled. Review costs and explicitly enable_paid_features."
    }
  }
}
resource "azurerm_virtual_network" "provider" {
  name                = "vnet-${var.lab_id}-provider"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.84.0.0/16"]
  tags                = local.tags
}
resource "azurerm_virtual_network" "consumer" {
  name                = "vnet-${var.lab_id}-consumer"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.85.0.0/16"]
  tags                = local.tags
}
resource "azurerm_subnet" "backend" {
  name                            = "backend"
  resource_group_name             = azurerm_resource_group.lab.name
  virtual_network_name            = azurerm_virtual_network.provider.name
  address_prefixes                = ["10.84.1.0/24"]
  default_outbound_access_enabled = false
}
resource "azurerm_subnet" "nat" {
  name                                          = "private-link-nat"
  resource_group_name                           = azurerm_resource_group.lab.name
  virtual_network_name                          = azurerm_virtual_network.provider.name
  address_prefixes                              = ["10.84.2.0/24"]
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}
resource "azurerm_subnet" "consumer" {
  name                              = "consumer"
  resource_group_name               = azurerm_resource_group.lab.name
  virtual_network_name              = azurerm_virtual_network.consumer.name
  address_prefixes                  = ["10.85.1.0/24"]
  private_endpoint_network_policies = "Disabled"
  default_outbound_access_enabled   = false
}
resource "azurerm_network_security_group" "backend" {
  name                = "nsg-${var.lab_id}-backend"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  security_rule {
    name                       = "AllowPrivateLinkHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.84.2.0/24"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHealthProbe"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "AzureLoadBalancer"
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
resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}
resource "azurerm_lb" "lab" {
  name                = "ilb-${var.lab_id}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address            = "10.84.1.10"
    private_ip_address_allocation = "Static"
  }
  tags = local.tags
}
resource "azurerm_lb_backend_address_pool" "lab" {
  name            = "web"
  loadbalancer_id = azurerm_lb.lab.id
}
resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  network_interface_id    = azurerm_network_interface.backend.id
  ip_configuration_name   = "primary"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lab.id
}
resource "azurerm_lb_probe" "web" {
  name            = "http"
  loadbalancer_id = azurerm_lb.lab.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}
resource "azurerm_lb_rule" "web" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.lab.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "private"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lab.id]
  probe_id                       = azurerm_lb_probe.web.id
  disable_outbound_snat          = true
}
resource "azurerm_private_link_service" "lab" {
  name                                        = "pls-${var.lab_id}"
  location                                    = var.location
  resource_group_name                         = azurerm_resource_group.lab.name
  visibility_subscription_ids                 = [var.subscription_id]
  auto_approval_subscription_ids              = [var.subscription_id]
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.lab.frontend_ip_configuration[0].id]
  nat_ip_configuration {
    name                       = "primary"
    primary                    = true
    private_ip_address         = "10.84.2.10"
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.nat.id
  }
  tags = local.tags
}
resource "azurerm_private_endpoint" "consumer" {
  name                = "pe-${var.lab_id}-service"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  subnet_id           = azurerm_subnet.consumer.id
  private_service_connection {
    name                           = "owned-service"
    private_connection_resource_id = azurerm_private_link_service.lab.id
    is_manual_connection           = false
  }
  tags = local.tags
}
resource "azurerm_private_dns_zone" "lab" {
  name                = "networklab.internal"
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}
resource "azurerm_private_dns_zone_virtual_network_link" "consumer" {
  name                  = "consumer"
  resource_group_name   = azurerm_resource_group.lab.name
  private_dns_zone_name = azurerm_private_dns_zone.lab.name
  virtual_network_id    = azurerm_virtual_network.consumer.id
  registration_enabled  = false
  tags                  = local.tags
}
resource "azurerm_private_dns_a_record" "web" {
  name                = "web"
  zone_name           = azurerm_private_dns_zone.lab.name
  resource_group_name = azurerm_resource_group.lab.name
  ttl                 = 30
  records             = [azurerm_private_endpoint.consumer.private_service_connection[0].private_ip_address]
  tags                = local.tags
}
resource "azurerm_network_interface" "backend" {
  name                = "nic-${var.lab_id}-backend"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.84.1.20"

  }
  tags = local.tags
}
resource "azurerm_linux_virtual_machine" "backend" {
  name                            = "vm-${var.lab_id}-backend"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.lab.name
  size                            = "Standard_B1s"
  admin_username                  = "labadmin"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.backend.id]
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
resource "azurerm_network_interface" "consumer" {
  name                = "nic-${var.lab_id}-consumer"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.consumer.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.85.1.20"

  }
  tags = local.tags
}
resource "azurerm_linux_virtual_machine" "consumer" {
  name                            = "vm-${var.lab_id}-consumer"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.lab.name
  size                            = "Standard_B1s"
  admin_username                  = "labadmin"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.consumer.id]
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


  boot_diagnostics {}
  custom_data = base64encode(templatefile("${path.module}/probe-cloud-init.yaml", {
    probe_script_b64 = base64encode(file("${path.module}/probe-consumer.sh"))
    probe_arguments  = ""
  }))
  tags = local.tags
}
