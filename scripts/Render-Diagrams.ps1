#Requires -Version 7.0
[CmdletBinding()]
param(
    [string]$Repository = (Split-Path $PSScriptRoot),
    [string]$MermaidCli = 'mmdc',
    [string]$BrowserExecutable,
    [string]$OutputDirectory = (Join-Path $Repository 'docs/diagrams'),
    [ValidateSet('svg', 'png')][string]$Format = 'svg'
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'Offline.Common.psm1') -Force
$version = Invoke-CheckedNative $MermaidCli @('--version')
if ($version.Trim() -ne '12.0.0') { throw 'Use @mermaid-js/mermaid-cli 12.0.0 to reproduce these diagrams.' }
$config = Join-Path ([IO.Path]::GetTempPath()) ('az700-mermaid-' + [guid]::NewGuid().ToString('N') + '.json')
$settings = @{headless=$true}
if ($BrowserExecutable) {
    if (-not (Test-Path -LiteralPath $BrowserExecutable -PathType Leaf)) { throw 'Browser executable does not exist.' }
    $settings.executablePath = $BrowserExecutable
}
$settings | ConvertTo-Json | Set-Content -LiteralPath $config
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
foreach ($source in Get-ChildItem -LiteralPath (Join-Path $Repository 'docs/diagrams') -Filter '*.mmd' -File) {
    $output = Join-Path $OutputDirectory "$($source.BaseName).$Format"
    Invoke-CheckedNative $MermaidCli @('-p', $config, '-i', $source.FullName, '-o', $output, '--size', '1600', '--no-font-embed') | Write-Host
}
