param([Parameter(Mandatory)][string]$ConfigurationPath)
$ErrorActionPreference = 'Stop'
$logPath = Join-Path $PSScriptRoot 'rras-status.log'
try {
    $configuration = Get-Content -LiteralPath $ConfigurationPath -Raw | ConvertFrom-Json
    if ((Get-WindowsFeature -Name RemoteAccess).InstallState -ne 'Installed') {
        throw 'RRAS feature installation is incomplete; check the required restart.'
    }
    $rras = Get-RemoteAccess -ErrorAction SilentlyContinue
    if (-not $rras -or $rras.RoutingStatus -ne 'Installed') {
        Install-RemoteAccess -VpnType RoutingOnly -ErrorAction Stop
    }
    Set-Service -Name RemoteAccess -StartupType Automatic
    Start-Service -Name RemoteAccess
    $peerAddresses = @($configuration.route_server_ips)
    if ($null -ne $configuration.bgp_asn -and $peerAddresses.Count -gt 0) {
        $router = Get-BgpRouter -ErrorAction SilentlyContinue
        if (-not $router) {
            Add-BgpRouter -BgpIdentifier $configuration.private_ip_address -LocalASN $configuration.bgp_asn
        } elseif ($router.LocalASN -ne $configuration.bgp_asn) {
            throw 'An existing BGP router has a different ASN; review guest configuration before changing it.'
        }
        # Permit BGP only from the two supplied Route Server instances.
        if (Get-NetFirewallRule -Name 'AzureNetworkLab-BGP' -ErrorAction SilentlyContinue) {
            Remove-NetFirewallRule -Name 'AzureNetworkLab-BGP'
        }
        New-NetFirewallRule -Name 'AzureNetworkLab-BGP' -DisplayName 'Azure network lab BGP' -Direction Inbound -Protocol TCP -LocalPort 179 -RemoteAddress $peerAddresses -Action Allow -Profile Any | Out-Null
        for ($index = 0; $index -lt $peerAddresses.Count; $index++) {
            $name = 'RouteServer' + ($index + 1)
            $peer = Get-BgpPeer -Name $name -ErrorAction SilentlyContinue
            if (-not $peer) {
                Add-BgpPeer -Name $name -LocalIPAddress $configuration.private_ip_address -PeerIPAddress $peerAddresses[$index] -PeerASN 65515
            } elseif ($peer.PeerIPAddress -ne $peerAddresses[$index] -or $peer.PeerASN -ne 65515) {
                throw "Existing peer $name differs from the intended Route Server peer; review before replacing it."
            }
        }
        $existingRoutes = @(Get-BgpCustomRoute -ErrorAction SilentlyContinue)
        foreach ($network in @($configuration.advertised_routes)) {
            if ($network -notin @($existingRoutes.Network)) { Add-BgpCustomRoute -Network $network }
        }
    }
    Set-Content -LiteralPath $logPath -Value 'CONFIGURED: RRAS settings written; verify BGP session convergence and data paths separately.'
} catch {
    Set-Content -LiteralPath $logPath -Value ('FAILED: ' + $_.Exception.Message)
    throw
}
