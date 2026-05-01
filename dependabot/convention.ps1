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

function Format-WithPrettier($content, $filePath) {
    $formatted = $content | & npx --yes prettier --stdin-filepath $filePath 2>$null | Out-String
    if ($LASTEXITCODE -eq 0 -and $formatted) {
        return $formatted
    }
    return $content
}

$configContent = Format-WithPrettier $configContent '.github/dependabot.yml'

$configPath = Join-Path $PWD '.github/dependabot.yml'
$configDirectory = Split-Path -Parent $configPath
New-Item -ItemType Directory -Path $configDirectory -Force | Out-Null

$existingContent = ''
if (Test-Path -LiteralPath $configPath -PathType Leaf) {
    $existingContent = Get-Content -LiteralPath $configPath -Raw
}

if ($existingContent -eq $configContent) {
    Write-Host "'$configPath' already matches the published standard."
    exit 0
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($configPath, $configContent, $utf8NoBom)

if ($existingContent -eq '') {
    Write-Host "Created '$configPath'."
} else {
    Write-Host "Updated '$configPath'."
}
