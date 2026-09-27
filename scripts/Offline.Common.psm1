Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-CheckedNative {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$FilePath, [string[]]$Arguments = @())
    $null = Get-Command -Name $FilePath -ErrorAction Stop
    $oldPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $lines = & $FilePath @Arguments 2>&1
        $code = $LASTEXITCODE
    } finally { $ErrorActionPreference = $oldPreference }
    if ($code -ne 0) {
        throw "Native command '$FilePath' exited with code $code.`n$($lines -join [Environment]::NewLine)"
    }
    return ($lines -join [Environment]::NewLine)
}

function Test-SourcePath {
    param([Parameter(Mandatory)][string]$Path)
    $p = $Path.Replace('\', '/')
    if ($p -match '(^|/)(\.git|\.terraform|\.local|node_modules|secrets)(/|$)' -or
        $p -match '(^|/)\.env($|\.)' -or $p -match '(^|/)(tfplan|crash\..*|secrets\.[^/]+)$' -or
        $p -match '\.(tfstate|tfplan|plan|tfvars|log|pem|pfx|key)(\..*)?$' -and $p -notmatch '\.tfvars\.example$' -or
        $p -match '(^|/)\.\.(/|$)' -or [IO.Path]::IsPathRooted($p)) { return $false }
    return $true
}

function Copy-SourceSnapshot {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Repository, [Parameter(Mandatory)][string]$Destination)
    if (Test-Path -LiteralPath $Destination) { throw 'Snapshot destination must not already exist.' }
    $files = (Invoke-CheckedNative git @('-C', $Repository, 'ls-files', '--cached', '--others', '--exclude-standard')) -split '\r?\n'
    New-Item -ItemType Directory -Path $Destination | Out-Null
    $count = 0
    foreach ($relative in $files | Sort-Object -Unique) {
        if (-not $relative -or -not (Test-SourcePath $relative)) { continue }
        $source = Join-Path $Repository $relative
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { continue }
        if ((Get-Item -LiteralPath $source).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Refusing source symlink: $relative" }
        $target = Join-Path $Destination $relative
        New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $target
        $count++
    }
    return $count
}

Export-ModuleMember -Function Invoke-CheckedNative, Test-SourcePath, Copy-SourceSnapshot
