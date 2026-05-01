#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$gitattributesPath = Join-Path $PWD '.gitattributes'
$templatePath = Join-Path $PSScriptRoot 'files' '.gitattributes'

$templateContent = Get-Content -LiteralPath $templatePath -Raw

if (-not (Test-Path -LiteralPath $gitattributesPath -PathType Leaf)) {
    Set-Content -LiteralPath $gitattributesPath -Value $templateContent -Encoding utf8NoBOM
    Write-Host "Created '$gitattributesPath'."
    exit 0
}

$existingContent = Get-Content -LiteralPath $gitattributesPath -Raw

if ($existingContent -eq $templateContent) {
    Write-Host "'$gitattributesPath' already matches the published standard."
    exit 0
}

Set-Content -LiteralPath $gitattributesPath -Value $templateContent -Encoding utf8NoBOM
Write-Host "Updated '$gitattributesPath'."
