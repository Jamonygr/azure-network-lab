locals {
  # Check if BGP should be configured
  configure_bgp = var.bgp_asn != null && length(var.route_server_ips) > 0

  # Base RRAS install script (always runs)
  rras_install_script = "Install-WindowsFeature -Name RemoteAccess,Routing,RSAT-RemoteAccess -IncludeManagementTools; Install-RemoteAccess -VpnType RoutingOnly; Set-Service RemoteAccess -StartupType Automatic; Start-Service RemoteAccess;"

  # BGP peer commands
  bgp_peer_commands = local.configure_bgp ? join(" ", [
    for i, ip in var.route_server_ips : 
    "Add-BgpPeer -Name 'RouteServer${i + 1}' -LocalIPAddress ${var.private_ip_address} -PeerIPAddress ${ip} -PeerASN 65515;"
  ]) : ""

  # BGP route commands  
  bgp_route_commands = local.configure_bgp && length(var.advertised_routes) > 0 ? join(" ", [
    for route in var.advertised_routes : "Add-BgpCustomRoute -Network ${route};"
  ]) : ""

  # BGP configuration script (only if configured)
  bgp_config_script = local.configure_bgp ? "Start-Sleep -Seconds 30; Add-BgpRouter -BgpIdentifier ${var.private_ip_address} -LocalASN ${var.bgp_asn}; ${local.bgp_peer_commands} ${local.bgp_route_commands} Get-BgpRouter; Get-BgpPeer;" : ""

  # Combined PowerShell command
  full_script = "powershell -ExecutionPolicy Unrestricted -Command \"${local.rras_install_script} ${local.bgp_config_script}\""
}

resource "azurerm_network_interface" "this" {
  name                  = "${var.name}-nic"
  resource_group_name   = var.resource_group_name
  location              = var.location
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
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

resource "azurerm_virtual_machine_extension" "rras" {
  name                 = "install-rras-bgp"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = local.full_script
  })

  tags = var.tags
}
