#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if ($args.Count -eq 0) {
    throw 'The input path argument is required.'
}

$inputJson = Get-Content -LiteralPath $args[0] -Raw | ConvertFrom-Json
$settings = $inputJson.settings

$ecosystems = @('github-actions')
if ($settings -and $settings.PSObject.Properties['ecosystems']) {
    $ecosystems = $settings.ecosystems
}

$interval = 'weekly'
if ($settings -and $settings.PSObject.Properties['interval']) {
    $interval = $settings.interval
}

$openPrLimit = 5
if ($settings -and $settings.PSObject.Properties['open-pull-requests-limit']) {
    $openPrLimit = $settings.'open-pull-requests-limit'
}

$ecosystemEntries = foreach ($ecosystem in $ecosystems) {
    $directory = if ($ecosystem -eq 'github-actions') { '/' } else { '/' }
    @"
  - package-ecosystem: "$ecosystem"
    directory: "$directory"
    schedule:
      interval: "$interval"
    open-pull-requests-limit: $openPrLimit
"@
}

$configContent = @"
version: 2
updates:
$($ecosystemEntries -join "`n")
"@

$configPath = Join-Path $PWD '.github/dependabot.yml'
$configDirectory = Split-Path -Parent $configPath
New-Item -ItemType Directory -Path $configDirectory -Force | Out-Null

if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    Set-Content -LiteralPath $configPath -Value $configContent -Encoding utf8NoBOM
    Write-Host "Created '$configPath'."
    exit 0
}

$existingContent = Get-Content -LiteralPath $configPath -Raw

if ($existingContent -eq $configContent) {
    Write-Host "'$configPath' already matches the published standard."
    exit 0
}

Set-Content -LiteralPath $configPath -Value $configContent -Encoding utf8NoBOM
Write-Host "Updated '$configPath'."
