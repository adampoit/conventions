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

$tsconfig = [ordered]@{
    compilerOptions = [ordered]@{
        target = if ($settings -and $settings.PSObject.Properties['target']) { $settings.target } else { 'ES2022' }
        module = if ($settings -and $settings.PSObject.Properties['module']) { $settings.module } else { 'NodeNext' }
        moduleResolution = if ($settings -and $settings.PSObject.Properties['moduleResolution']) { $settings.moduleResolution } else { 'NodeNext' }
        outDir = if ($settings -and $settings.PSObject.Properties['outDir']) { $settings.outDir } else { 'dist' }
        rootDir = if ($settings -and $settings.PSObject.Properties['rootDir']) { $settings.rootDir } else { 'src' }
        strict = if ($settings -and $settings.PSObject.Properties['strict']) { [bool]$settings.strict } else { $true }
        noEmitOnError = if ($settings -and $settings.PSObject.Properties['noEmitOnError']) { [bool]$settings.noEmitOnError } else { $true }
        skipLibCheck = if ($settings -and $settings.PSObject.Properties['skipLibCheck']) { [bool]$settings.skipLibCheck } else { $true }
        esModuleInterop = if ($settings -and $settings.PSObject.Properties['esModuleInterop']) { [bool]$settings.esModuleInterop } else { $true }
    }
    include = @('src/**/*.ts')
} | ConvertTo-Json -Depth 10

function Format-WithPrettier($content, $filePath) {
    $formatted = $content | & npx --yes prettier --stdin-filepath $filePath 2>$null | Out-String
    if ($LASTEXITCODE -eq 0 -and $formatted) {
        return $formatted
    }
    return $content
}

$tsconfig = Format-WithPrettier $tsconfig 'tsconfig.json'

$configPath = Join-Path $PWD 'tsconfig.json'

$existingContent = ''
if (Test-Path -LiteralPath $configPath -PathType Leaf) {
    $existingContent = Get-Content -LiteralPath $configPath -Raw
}

if ($existingContent -eq $tsconfig) {
    Write-Host "'$configPath' already matches the published standard."
    exit 0
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($configPath, $tsconfig, $utf8NoBom)

if ($existingContent -eq '') {
    Write-Host "Created '$configPath'."
} else {
    Write-Host "Updated '$configPath'."
}
