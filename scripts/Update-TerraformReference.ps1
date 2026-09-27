#Requires -Version 7.0
[CmdletBinding()]
param([string]$Repository = (Split-Path $PSScriptRoot), [string]$TerraformDocs = 'terraform-docs', [switch]$Check)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'Offline.Common.psm1') -Force
$roots = @([pscustomobject]@{Name='root'; Path=$Repository})
foreach ($group in @('modules', 'examples')) {
    foreach ($directory in Get-ChildItem -LiteralPath (Join-Path $Repository $group) -Directory) {
        if (Get-ChildItem -LiteralPath $directory.FullName -Filter '*.tf' -File) {
            $roots += [pscustomobject]@{Name="$group/$($directory.Name)"; Path=$directory.FullName}
        }
    }
}
foreach ($root in $roots) {
    $content = (Invoke-CheckedNative $TerraformDocs @('markdown', 'table', '--hide', 'resources', $root.Path)).Replace("`r`n", "`n").TrimEnd() + "`n"
    $destination = Join-Path $Repository "reference/$($root.Name).md"
    if ($Check) {
        if (-not (Test-Path -LiteralPath $destination) -or [IO.File]::ReadAllText($destination).Replace("`r`n", "`n") -cne $content) {
            throw "Generated reference is stale: reference/$($root.Name).md"
        }
    } else {
        New-Item -ItemType Directory -Path (Split-Path $destination) -Force | Out-Null
        [IO.File]::WriteAllText($destination, $content, [Text.UTF8Encoding]::new($false))
    }
}
Write-Host "Terraform references: $($roots.Count) checked/generated."
$index = @('# Terraform configuration reference', '', 'Generated with terraform-docs 0.24.0. These tables describe configuration inputs and outputs; they are not evidence of an Azure deployment.', '', 'Regenerate with `pwsh ./scripts/Update-TerraformReference.ps1`; check consistency with `-Check`.', '')
foreach ($root in $roots) { $index += "- [$($root.Name)]($($root.Name).md)" }
$indexText = ($index -join "`n") + "`n"
$indexPath = Join-Path $Repository 'reference/README.md'
if ($Check) {
    if (-not (Test-Path -LiteralPath $indexPath) -or [IO.File]::ReadAllText($indexPath).Replace("`r`n", "`n") -cne $indexText) { throw 'Generated reference index is stale.' }
} else { [IO.File]::WriteAllText($indexPath, $indexText, [Text.UTF8Encoding]::new($false)) }
