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

$configPath = Join-Path $PWD '.prettierrc.json'

if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    Set-Content -LiteralPath $configPath -Value $config -Encoding utf8NoBOM
    Write-Host "Created '$configPath'."
    exit 0
}

$existingContent = Get-Content -LiteralPath $configPath -Raw

if ($existingContent -eq $config) {
    Write-Host "'$configPath' already matches the published standard."
    exit 0
}

Set-Content -LiteralPath $configPath -Value $config -Encoding utf8NoBOM
Write-Host "Updated '$configPath'."
