#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$cpmContent = @"
<Project>
  <PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>
</Project>
"@

$cpmPath = Join-Path $PWD 'Directory.Packages.props'

if (-not (Test-Path -LiteralPath $cpmPath -PathType Leaf)) {
    Set-Content -LiteralPath $cpmPath -Value $cpmContent -Encoding utf8NoBOM
    Write-Host "Created '$cpmPath'."
    exit 0
}

$existingContent = Get-Content -LiteralPath $cpmPath -Raw

if ($existingContent -eq $cpmContent) {
    Write-Host "'$cpmPath' already matches the published standard."
    exit 0
}

Set-Content -LiteralPath $cpmPath -Value $cpmContent -Encoding utf8NoBOM
Write-Host "Updated '$cpmPath'."
