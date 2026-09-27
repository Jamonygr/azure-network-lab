#requires -Version 7.0
# Parsing and native argument decoding only. No guest script or Azure command runs.
BeforeAll {
    $repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
    $moduleDirectory = Join-Path $repositoryRoot 'modules/vm-windows-nva'
    $hcl = Get-Content -LiteralPath (Join-Path $moduleDirectory 'main.tf') -Raw
    $guestSource = Get-Content -LiteralPath (Join-Path $moduleDirectory 'configure-rras.ps1') -Raw
    $template = Get-Content -LiteralPath (Join-Path $moduleDirectory 'bootstrap-rras.ps1.tftpl') -Raw
    $fixture = @{ private_ip_address = '10.1.8.10'; bgp_asn = 65501; route_server_ips = @('10.1.7.4', '10.1.7.5'); advertised_routes = @('10.100.0.0/16') } | ConvertTo-Json -Compress
    $configurationBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($fixture))
    $guestBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $moduleDirectory 'configure-rras.ps1')))
    $rendered = $template.Replace('${configuration_base64}', $configurationBase64).Replace('${configure_script_base64}', $guestBase64)
    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($rendered))
    $launcherLiteral = ([regex]::Match($hcl, '(?m)^\s*full_script\s*=\s*(".*")\s*$')).Groups[1].Value
    if (-not $launcherLiteral) { throw 'Could not read the actual Terraform launcher string.' }
    $launcher = $launcherLiteral.Replace('${base64encode(local.bootstrap_script)}', $encoded) | ConvertFrom-Json
    if ($IsWindows -and -not ('NvaArgumentAudit' -as [type])) {
        Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class NvaArgumentAudit { [DllImport("shell32.dll", SetLastError=true)] public static extern IntPtr CommandLineToArgvW([MarshalAs(UnmanagedType.LPWStr)] string value, out int count); [DllImport("kernel32.dll")] public static extern IntPtr LocalFree(IntPtr pointer); }'
    }
    function Read-NativeArguments([string]$CommandLine) {
        $count = 0
        $pointer = [NvaArgumentAudit]::CommandLineToArgvW($CommandLine, [ref]$count)
        if ($pointer -eq [IntPtr]::Zero) { throw 'Native command-line parsing failed.' }
        try {
            $values = @()
            for ($index = 0; $index -lt $count; $index++) {
                $values += [Runtime.InteropServices.Marshal]::PtrToStringUni([Runtime.InteropServices.Marshal]::ReadIntPtr($pointer, $index * [IntPtr]::Size))
            }
            return ,$values
        } finally { [void][NvaArgumentAudit]::LocalFree($pointer) }
    }
}
Describe 'RRAS bootstrap transport without guest execution' {
    It 'survives the Windows native argument boundary as one command body' -Skip:(-not $IsWindows) {
        $arguments = Read-NativeArguments $launcher
        $arguments.Count | Should -Be 7
        $arguments[0] | Should -BeExactly 'powershell.exe'
        $arguments[5] | Should -BeExactly '-Command'
        $payload = [regex]::Match($arguments[6], "FromBase64String\('([A-Za-z0-9+/=]+)'\)").Groups[1].Value
        [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($payload)) | Should -BeExactly $rendered
    }
    It 'demonstrates that the former nested-quote transport loses script text' -Skip:(-not $IsWindows) {
        $badLauncher = 'powershell.exe -Command "' + $rendered + '"'
        $arguments = Read-NativeArguments $badLauncher
        ($arguments[2..($arguments.Count - 1)] -join ' ') | Should -Not -BeExactly $rendered
    }
    It 'decodes to valid PowerShell with the original guest payload intact' {
        $recovered = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encoded))
        $tokens = $null; $parseErrors = $null
        [Management.Automation.Language.Parser]::ParseInput($recovered, [ref]$tokens, [ref]$parseErrors) | Out-Null
        $parseErrors.Count | Should -Be 0
        $embedded = [regex]::Matches($recovered, "FromBase64String\('([A-Za-z0-9+/=]+)'\)")
        $embedded.Count | Should -Be 2
        $config = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($embedded[0].Groups[1].Value)) | ConvertFrom-Json
        $config.route_server_ips.Count | Should -Be 2
        $config.bgp_asn | Should -Be 65501
        [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($embedded[1].Groups[1].Value)) | Should -BeExactly $guestSource
    }
    It 'has valid guest syntax and rethrows every caught configuration failure' {
        $tokens = $null; $parseErrors = $null
        $ast = [Management.Automation.Language.Parser]::ParseInput($guestSource, [ref]$tokens, [ref]$parseErrors)
        $parseErrors.Count | Should -Be 0
        $catches = @($ast.FindAll({ param($node) $node -is [Management.Automation.Language.CatchClauseAst] }, $true))
        $catches.Count | Should -BeGreaterThan 0
        foreach ($catch in $catches) { $catch.Body.Statements[-1] | Should -BeOfType ([Management.Automation.Language.ThrowStatementAst]) }
        $stopAssignment = @($ast.FindAll({ param($node)
            $node -is [Management.Automation.Language.AssignmentStatementAst] -and $node.Left.Extent.Text -eq '$ErrorActionPreference' -and $node.Right.Extent.Text -eq "'Stop'"
        }, $true))
        $stopAssignment.Count | Should -Be 1
    }
}
