#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$gitignorePath = Join-Path $PWD '.gitignore'
$templatePath = Join-Path $PSScriptRoot 'files' '.gitignore'

# Read template entries (non-empty, non-comment lines)
$templateEntries = @(Get-Content -LiteralPath $templatePath |
    Where-Object { $_.Trim() -ne '' -and -not $_.Trim().StartsWith('#') } |
    ForEach-Object { $_.Trim() })

# Read existing entries
$existingEntries = @()
if (Test-Path -LiteralPath $gitignorePath) {
    $existingRaw = Get-Content -LiteralPath $gitignorePath -Raw
    $existingEntries = @(($existingRaw -split "`r?`n") |
        Where-Object { $_.Trim() -ne '' -and -not $_.Trim().StartsWith('#') } |
        ForEach-Object { $_.Trim() })
}

$missingEntries = $templateEntries | Where-Object { $existingEntries -notcontains $_ }

if ($missingEntries.Count -eq 0) {
    Write-Host "'.gitignore' already contains all published entries."
    exit 0
}

$output = [System.Collections.Generic.List[string]]::new()

if (Test-Path -LiteralPath $gitignorePath) {
    $existingContent = Get-Content -LiteralPath $gitignorePath -Raw
    $output.Add($existingContent.TrimEnd("`r", "`n"))
    $output.Add('')
    $output.Add('# Added by gitignore-dotnet convention')
} else {
    $output.Add('# Created by gitignore-dotnet convention')
}

foreach ($entry in $missingEntries) {
    $output.Add($entry)
}

$finalContent = ($output -join "`n") + "`n"
Set-Content -LiteralPath $gitignorePath -Value $finalContent -Encoding utf8NoBOM

if (Test-Path -LiteralPath $gitignorePath) {
    Write-Host "Added $($missingEntries.Count) entries to '.gitignore'."
} else {
    Write-Host "Created '.gitignore' with $($missingEntries.Count) entries."
}
