resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.ctx.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.ctx.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.ctx.location
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

  tags = var.ctx.tags
}

resource "azurerm_network_interface_backend_address_pool_association" "this" {
  count = var.join_lb_backend_pool ? 1 : 0

  network_interface_id    = azurerm_network_interface.this.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.lb_backend_pool_id
}

# Supported guest agents download extension packages via HostGAPlugin (168.63.129.16,
# TCP 80/32526). The bootstrap payload is inline and never fetches remote scripts.
resource "azurerm_virtual_machine_extension" "web" {
  count                      = var.install_web_server ? 1 : 0
  name                       = "bootstrap-web"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  settings = jsonencode({
    commandToExecute = "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command \"& ([ScriptBlock]::Create([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('${filebase64("${path.module}/bootstrap-web.ps1")}'))))\""
  })
  tags = var.ctx.tags
}
