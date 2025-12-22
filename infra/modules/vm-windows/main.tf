resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [azurerm_network_interface.this.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-core-smalldisk"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_network_interface_backend_address_pool_association" "this" {
  count = var.join_lb_backend_pool ? 1 : 0

  network_interface_id    = azurerm_network_interface.this.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.lb_backend_pool_id
}
