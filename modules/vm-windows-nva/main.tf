locals {
  # Check if BGP should be configured
  configure_bgp = var.bgp_asn != null && length(var.route_server_ips) > 0

  # BGP peer commands for the startup script
  bgp_peer_commands = local.configure_bgp ? join("\n", [
    for i, ip in var.route_server_ips :
    "if (-not (Get-BgpPeer -Name 'RouteServer${i + 1}' -ErrorAction SilentlyContinue)) { Add-BgpPeer -Name 'RouteServer${i + 1}' -LocalIPAddress '${var.private_ip_address}' -PeerIPAddress '${ip}' -PeerASN 65515 }"
  ]) : ""

  # BGP route commands
  bgp_route_commands = local.configure_bgp && length(var.advertised_routes) > 0 ? join("\n", [
    for route in var.advertised_routes :
    "Add-BgpCustomRoute -Network '${route}' -ErrorAction SilentlyContinue"
  ]) : ""

  # BGP configuration for startup script (use conditional inside heredoc)
  bgp_startup_config = local.configure_bgp ? "# Configure BGP Router if not exists\nif (-not (Get-BgpRouter -ErrorAction SilentlyContinue)) {\n    Add-BgpRouter -BgpIdentifier '${var.private_ip_address}' -LocalASN ${var.bgp_asn}\n}\n# Add BGP Peers\n${local.bgp_peer_commands}\n# Add custom routes\n${local.bgp_route_commands}" : ""

  # Startup script that runs after every boot to ensure RRAS and BGP are configured
  startup_script_content = <<-EOT
# RRAS and BGP Configuration Script
# This script runs at startup to ensure RRAS is running and BGP is configured

$logFile = "C:\\rras-config.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logFile -Value "`n[$timestamp] Starting RRAS configuration..."

try {
    # Check if RRAS is installed
    $rrasFeature = Get-WindowsFeature -Name RemoteAccess
    if ($rrasFeature.InstallState -ne 'Installed') {
        Add-Content -Path $logFile -Value "[$timestamp] RRAS feature not installed, waiting for installation..."
        exit 0
    }

    # Install RemoteAccess routing if not configured
    $rrasConfig = Get-RemoteAccess -ErrorAction SilentlyContinue
    if (-not $rrasConfig -or $rrasConfig.RoutingStatus -ne 'Installed') {
        Add-Content -Path $logFile -Value "[$timestamp] Installing RemoteAccess routing..."
        Install-RemoteAccess -VpnType RoutingOnly -ErrorAction Stop
    }

    # Ensure service is set to automatic and running
    Set-Service RemoteAccess -StartupType Automatic -ErrorAction SilentlyContinue
    $svc = Get-Service RemoteAccess
    if ($svc.Status -ne 'Running') {
        Add-Content -Path $logFile -Value "[$timestamp] Starting RemoteAccess service..."
        Start-Service RemoteAccess -ErrorAction Stop
        Start-Sleep -Seconds 10
    }

    Add-Content -Path $logFile -Value "[$timestamp] RemoteAccess service is running"

    ${local.bgp_startup_config}

    Add-Content -Path $logFile -Value "[$timestamp] BGP configuration complete"
    Get-BgpRouter | Out-File -Append $logFile
    Get-BgpPeer | Out-File -Append $logFile

} catch {
    Add-Content -Path $logFile -Value "[$timestamp] ERROR: $($_.Exception.Message)"
}
EOT

  # Initial installation script - installs features and creates startup task
  full_script = <<-EOT
powershell -ExecutionPolicy Unrestricted -Command "
# Install RRAS Windows Features
Write-Host 'Installing RRAS features...'
Install-WindowsFeature -Name RemoteAccess,Routing,RSAT-RemoteAccess -IncludeManagementTools

# Create startup script
$scriptContent = @'
${local.startup_script_content}
'@
$scriptPath = 'C:\\ConfigureRRAS.ps1'
Set-Content -Path $scriptPath -Value $scriptContent -Force

# Create scheduled task to run at startup
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-ExecutionPolicy Bypass -File C:\\ConfigureRRAS.ps1'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Remove existing task if exists
Unregister-ScheduledTask -TaskName 'ConfigureRRAS' -Confirm:`$false -ErrorAction SilentlyContinue

# Register new task
Register-ScheduledTask -TaskName 'ConfigureRRAS' -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force

Write-Host 'Scheduled task created. Running initial configuration...'

# Run the script now (will work after reboot if features need it)
& $scriptPath

# Check if reboot is needed
$feature = Get-WindowsFeature -Name RemoteAccess
if ($feature.InstallState -eq 'InstallPending') {
    Write-Host 'Reboot required to complete installation. Scheduling reboot...'
    shutdown /r /t 60 /c 'Rebooting to complete RRAS installation'
}
"
EOT
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
