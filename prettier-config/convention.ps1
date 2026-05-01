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

$semi = if ($settings -and $settings.PSObject.Properties['semi']) { $settings.semi } else { $true }
$singleQuote = if ($settings -and $settings.PSObject.Properties['singleQuote']) { $settings.singleQuote } else { $true }
$useTabs = if ($settings -and $settings.PSObject.Properties['useTabs']) { $settings.useTabs } else { $true }
$tabWidth = if ($settings -and $settings.PSObject.Properties['tabWidth']) { $settings.tabWidth } else { 4 }
$trailingComma = if ($settings -and $settings.PSObject.Properties['trailingComma']) { $settings.trailingComma } else { 'all' }
$printWidth = if ($settings -and $settings.PSObject.Properties['printWidth']) { $settings.printWidth } else { 120 }

$config = [ordered]@{
    semi = [bool]$semi
    singleQuote = [bool]$singleQuote
    useTabs = [bool]$useTabs
    tabWidth = [int]$tabWidth
    trailingComma = [string]$trailingComma
    printWidth = [int]$printWidth
    overrides = @(
        [ordered]@{
            files = @('*.{json,yml,yaml}')
            options = [ordered]@{
                useTabs = $false
                tabWidth = 2
            }
        }
    )
} | ConvertTo-Json -Depth 10

function Format-WithPrettier($content, $filePath) {
    $formatted = $content | & npx --yes prettier --stdin-filepath $filePath 2>$null | Out-String
    if ($LASTEXITCODE -eq 0 -and $formatted) {
        return $formatted
    }
    return $content
}

$config = Format-WithPrettier $config '.prettierrc.json'

$configPath = Join-Path $PWD '.prettierrc.json'

$existingContent = ''
if (Test-Path -LiteralPath $configPath -PathType Leaf) {
    $existingContent = Get-Content -LiteralPath $configPath -Raw
}

if ($existingContent -eq $config) {
    Write-Host "'$configPath' already matches the published standard."
    exit 0
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($configPath, $config, $utf8NoBom)

if ($existingContent -eq '') {
    Write-Host "Created '$configPath'."
} else {
    Write-Host "Updated '$configPath'."
}
