#Requires -Version 7.0
[CmdletBinding()]
param(
    [string]$Repository = (Split-Path $PSScriptRoot),
    [string]$Terraform = 'terraform', [string]$Python = 'python',
    [string]$TFLint = 'tflint', [string]$Trivy = 'trivy',
    [string]$Gitleaks = 'gitleaks', [string]$TerraformDocs = 'terraform-docs',
    [string]$EvidencePath = (Join-Path $Repository '.local/validation-summary.json')
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'Offline.Common.psm1') -Force
$results = [Collections.Generic.List[object]]::new()
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('az700-offline-' + [guid]::NewGuid().ToString('N'))
function Invoke-Check([string]$Name, [scriptblock]$Action) {
    try {
        & $Action | Out-Host
        $results.Add([ordered]@{check=$Name; status='PASS'})
    } catch {
        Write-Warning "$Name failed: $($_.Exception.Message)"
        $results.Add([ordered]@{check=$Name; status='FAIL'})
    }
}
function Invoke-MockTest([string]$Root, [string[]]$ExtraArguments = @()) {
    $output = Invoke-CheckedNative $Terraform (@("-chdir=$Root", 'test', '-no-color') + $ExtraArguments)
    if ($output -notmatch 'Success!\s+[1-9][0-9]* passed') { throw 'Terraform did not report any passed mock tests.' }
    Write-Output $output
}
try {
    $count = Copy-SourceSnapshot -Repository $Repository -Destination $scratch
    Write-Host "Checking $count source files in $scratch; deployment artifacts were excluded."
    $version = Invoke-CheckedNative $Terraform @('version', '-json') | ConvertFrom-Json
    if ($version.terraform_version -ne '1.16.4') { throw 'Use Terraform 1.16.4 for reproducible validation.' }
    foreach ($test in Get-ChildItem -LiteralPath $scratch -Filter '*.tftest.hcl' -Recurse -File) {
        $source = [IO.File]::ReadAllText($test.FullName)
        if ($source -notmatch 'mock_provider\s+"azurerm"' -or
            [regex]::Matches($source, '(?m)^run\s+"').Count -ne [regex]::Matches($source, '(?m)^\s*command\s*=\s*plan\s*$').Count) {
            throw "Refusing a test without explicit mocked plan runs: $($test.Name)"
        }
    }
    Invoke-Check 'format' { Invoke-CheckedNative $Terraform @("-chdir=$scratch", 'fmt', '-check', '-recursive') }
    $roots = @($scratch) + @(Get-ChildItem -LiteralPath (Join-Path $scratch 'examples') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'main.tf') } | ForEach-Object FullName)
    foreach ($root in $roots) {
        $name = if ($root -eq $scratch) {'root'} else {Split-Path $root -Leaf}
        Invoke-Check "$name/init" { Invoke-CheckedNative $Terraform @("-chdir=$root", 'init', '-backend=false', '-input=false', '-lockfile=readonly', '-no-color') }
        Invoke-Check "$name/validate" { Invoke-CheckedNative $Terraform @("-chdir=$root", 'validate', '-no-color') }
        if ($root -eq $scratch) {
            Invoke-Check 'root/contracts' { Invoke-MockTest $root @("-filter=$(Join-Path 'tests' 'root-contracts.tftest.hcl')") }
            Invoke-Check 'root/module-contracts' { Invoke-MockTest $root @("-filter=$(Join-Path 'tests' 'root-modules.tftest.hcl')") }
            foreach ($profile in Get-ChildItem -LiteralPath (Join-Path $scratch 'profiles') -Filter '*.tfvars.example' -File) {
                Invoke-Check "root/profile/$($profile.BaseName)" {
                    Invoke-MockTest $root @("-filter=$(Join-Path 'tests' 'root-profile.tftest.hcl')", "-var-file=$($profile.FullName)")
                }
            }
        } else {
            Invoke-Check "$name/mock-tests" { Invoke-MockTest $root }
        }
    }
    Invoke-Check 'lint' { Invoke-CheckedNative $TFLint @("--chdir=$scratch", '--recursive', '--config', (Join-Path $scratch '.tflint.hcl')) }
    # Synthetic context exists only in the disposable source snapshot, after tests.
    @'
subscription_id = "00000000-0000-0000-0000-000000000000"
ctx = { project = "az700scan", location = "eastus2", tags = {} }
'@ | Set-Content -LiteralPath (Join-Path $scratch 'scanner.auto.tfvars')
    foreach ($example in Get-ChildItem -LiteralPath (Join-Path $scratch 'examples') -Directory) {
        @'
subscription_id = "00000000-0000-0000-0000-000000000000"
tenant_id = "00000000-0000-0000-0000-000000000000"
lab_id = "az700scan"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMockFixtureNotAnAuthenticationCredential"
vpn_aad_audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
vpn_aad_issuer_url = "https://sts.windows.net/00000000-0000-0000-0000-000000000000/"
vpn_aad_tenant_url = "https://login.microsoftonline.com/00000000-0000-0000-0000-000000000000"
'@ | Set-Content -LiteralPath (Join-Path $example.FullName 'scanner.auto.tfvars')
    }
    foreach ($profile in Get-ChildItem -LiteralPath (Join-Path $scratch 'profiles') -Filter '*.tfvars.example' -File) {
        Invoke-Check "security/$($profile.BaseName)" {
            Invoke-CheckedNative $Trivy @('config', '--skip-check-update', '--disable-telemetry', '--skip-version-check', '--severity', 'HIGH,CRITICAL', '--exit-code', '1', '--misconfig-scanners', 'terraform', '--tf-vars', $profile.FullName, $scratch)
        }
    }
    Invoke-Check 'secrets' { Invoke-CheckedNative $Gitleaks @('dir', $scratch, '--no-banner', '--redact') }
    Invoke-Check 'python-tests' { Invoke-CheckedNative $Python @('-m', 'unittest', 'discover', '-s', (Join-Path $scratch 'tests/tooling'), '-p', 'test_*.py') }
    Invoke-Check 'documentation-and-guardrails' { Invoke-CheckedNative $Python @((Join-Path $scratch 'scripts/check_repository.py'), $scratch) }
    Invoke-Check 'generated-references' { & (Join-Path $scratch 'scripts/Update-TerraformReference.ps1') -Repository $scratch -TerraformDocs $TerraformDocs -Check }
    Invoke-Check 'windows-powershell-tests' {
        Import-Module Pester -MinimumVersion 5.7.1
        $testResult = Invoke-Pester -Path (Join-Path $scratch 'tests/tooling') -PassThru -Output Detailed
        if ($testResult.FailedCount -gt 0 -or $testResult.PassedCount -eq 0) { throw 'PowerShell tests failed or none ran.' }
    }
} catch {
    Write-Warning $_.Exception.Message
    $results.Add([ordered]@{check='runner';status='FAIL'})
} finally {
    $results.Add([ordered]@{check='Azure deployment and live acceptance';status='NOT RUN'})
    New-Item -ItemType Directory -Path (Split-Path $EvidencePath) -Force | Out-Null
    [ordered]@{timestamp=[DateTime]::UtcNow.ToString('o'); checks=@($results.ToArray()); sourceOnly=$true} | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $EvidencePath
    Write-Host "Sanitized summary: $EvidencePath"
}
if (@($results | Where-Object status -eq 'FAIL').Count -gt 0) { throw 'Offline validation failed; inspect the local output.' }
