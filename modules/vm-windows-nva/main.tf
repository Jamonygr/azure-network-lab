locals {
  rras_configuration = {
    private_ip_address = var.private_ip_address
    bgp_asn            = var.bgp_asn
    route_server_ips   = var.route_server_ips
    advertised_routes  = var.advertised_routes
  }
  bootstrap_script = templatefile("${path.module}/bootstrap-rras.ps1.tftpl", {
    configuration_base64    = base64encode(jsonencode(local.rras_configuration))
    configure_script_base64 = filebase64("${path.module}/configure-rras.ps1")
  })
  # Only base64 crosses the native command-line boundary. Nested script quotes,
  # dollar signs and newlines are decoded inside PowerShell, never by cmd.exe.
  full_script = "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command \"& ([ScriptBlock]::Create([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('${base64encode(local.bootstrap_script)}'))))\""
}

resource "azurerm_network_interface" "this" {
  name                  = "${var.name}-nic"
  resource_group_name   = var.resource_group_name
  location              = var.ctx.location
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
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

resource "azurerm_virtual_machine_extension" "rras" {
  name                 = "install-rras-bgp"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = local.full_script
  })

  tags = var.ctx.tags
}
