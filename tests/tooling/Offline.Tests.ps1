BeforeAll {
    Get-Module -Name Offline.Common -All | Remove-Module -Force
    Import-Module (Join-Path $PSScriptRoot '../../scripts/Offline.Common.psm1') -Force
}
Describe 'Source-only validation boundary' {
    It 'excludes deployment or credential file <Path>' -ForEach @(
        @{Path='terraform.tfvars'}, @{Path='demo.tfstate.backup'}, @{Path='tfplan'},
        @{Path='examples/a/credentials.pem'}, @{Path='.terraform/cache/file.tf'},
        @{Path='.local/evidence.json'}, @{Path='.env'}, @{Path='../outside.tf'}
    ) { Test-SourcePath $Path | Should -BeFalse }
    It 'retains non-secret authored source <Path>' -ForEach @(
        @{Path='main.tf'}, @{Path='.terraform.lock.hcl'}, @{Path='profiles/minimal.tfvars.example'},
        @{Path='tests/root.tftest.hcl'}, @{Path='docs/diagram.svg'}
    ) { Test-SourcePath $Path | Should -BeTrue }
    It 'propagates a failed native command' {
        { Invoke-CheckedNative pwsh @('-NoProfile', '-Command', 'exit 17') } | Should -Throw '*code 17*'
    }
    It 'returns successful native output' {
        Invoke-CheckedNative pwsh @('-NoProfile', '-Command', 'Write-Output checked; exit 0') | Should -Be 'checked'
    }
    It 'never overwrites an existing snapshot destination' {
        { Copy-SourceSnapshot -Repository $TestDrive -Destination $TestDrive } | Should -Throw '*must not already exist*'
    }
}
Describe 'Missing tools and snapshot contents' {
    It 'fails when a native executable is missing' {
        { Invoke-CheckedNative 'az700-nonexistent-executable-1729' } | Should -Throw
    }
    It 'copies authored source and excludes synthetic deployment files' {
        $source = Join-Path $TestDrive 'source'
        $destination = Join-Path $TestDrive 'snapshot'
        New-Item -ItemType Directory -Path $source | Out-Null
        Set-Content (Join-Path $source 'main.tf') '# source'
        Set-Content (Join-Path $source 'terraform.tfvars') '# synthetic local config'
        Set-Content (Join-Path $source 'terraform.tfstate') '# synthetic local state'
        Mock -ModuleName Offline.Common Invoke-CheckedNative { "main.tf`nterraform.tfvars`nterraform.tfstate" }
        Copy-SourceSnapshot -Repository $source -Destination $destination | Should -Be 1
        Test-Path (Join-Path $destination 'main.tf') | Should -BeTrue
        Test-Path (Join-Path $destination 'terraform.tfvars') | Should -BeFalse
        Test-Path (Join-Path $destination 'terraform.tfstate') | Should -BeFalse
    }
}
