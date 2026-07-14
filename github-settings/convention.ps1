#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$githubDirectory = Join-Path $PWD '.github'
New-Item -ItemType Directory -Path $githubDirectory -Force | Out-Null
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

$settingsPath = Join-Path $githubDirectory 'settings.yml'
$settingsTemplatePath = Join-Path $PSScriptRoot 'files' 'settings.yml'
$settingsContent = Get-Content -LiteralPath $settingsTemplatePath -Raw
$existingSettingsContent = ''
if (Test-Path -LiteralPath $settingsPath -PathType Leaf) {
    $existingSettingsContent = Get-Content -LiteralPath $settingsPath -Raw
}

function Get-RequiredStatusCheckRules {
    param([string] $Content)

    $lines = $Content -split '\r?\n'
    $rules = [System.Collections.Generic.List[string]]::new()

    for ($lineIndex = 0; $lineIndex -lt $lines.Count; $lineIndex++) {
        if ($lines[$lineIndex] -notmatch '^(?<indent>\s*)-\s+type:\s*required_status_checks(?:\s+#.*)?\s*$') {
            continue
        }

        $ruleIndent = $Matches.indent.Length
        $ruleLines = [System.Collections.Generic.List[string]]::new()
        $ruleLines.Add($lines[$lineIndex])

        for ($nextLineIndex = $lineIndex + 1; $nextLineIndex -lt $lines.Count; $nextLineIndex++) {
            $nextLine = $lines[$nextLineIndex]
            if ($nextLine -match '^\s*$') {
                $ruleLines.Add($nextLine)
                continue
            }

            $nextLine -match '^(?<indent>\s*)' | Out-Null
            if ($Matches.indent.Length -le $ruleIndent) {
                break
            }

            $ruleLines.Add($nextLine)
        }

        while ($ruleLines.Count -gt 0 -and $ruleLines[$ruleLines.Count - 1] -match '^\s*$') {
            $ruleLines.RemoveAt($ruleLines.Count - 1)
        }

        $rules.Add(($ruleLines -join "`n"))
        $lineIndex += $ruleLines.Count - 1
    }

    return $rules
}

$requiredStatusCheckRules = @(Get-RequiredStatusCheckRules -Content $existingSettingsContent)
if ($requiredStatusCheckRules.Count -gt 0) {
    $statusCheckMarker = '      # Project-specific required status checks are preserved below this line.'
    $preservedRules = $requiredStatusCheckRules -join "`n"
    if (-not $settingsContent.Contains($statusCheckMarker)) {
        throw "The settings template is missing the required status check insertion marker."
    }
    $settingsContent = $settingsContent.Replace($statusCheckMarker, "$statusCheckMarker`n$preservedRules")
}

if ($existingSettingsContent -eq $settingsContent) {
    Write-Host "'$settingsPath' already matches the published standard."
} else {
    [System.IO.File]::WriteAllText($settingsPath, $settingsContent, $utf8NoBom)
    $action = if ($existingSettingsContent -eq '') { 'Created' } else { 'Updated' }
    Write-Host "$action '$settingsPath'."
}

$codeownersPath = Join-Path $githubDirectory 'CODEOWNERS'
$codeownersTemplatePath = Join-Path $PSScriptRoot 'files' 'CODEOWNERS'
$managedCodeownersBlock = (Get-Content -LiteralPath $codeownersTemplatePath -Raw).TrimEnd()
$existingCodeownersContent = ''
if (Test-Path -LiteralPath $codeownersPath -PathType Leaf) {
    $existingCodeownersContent = Get-Content -LiteralPath $codeownersPath -Raw
}

$managedBlockPattern = '(?ms)^# BEGIN github-settings convention\r?\n.*?^# END github-settings convention\r?\n?'
$preservedCodeownersContent = [regex]::Replace($existingCodeownersContent, $managedBlockPattern, '')
$managedCodeownerEntries = @('/.github/CODEOWNERS @adampoit', '/.github/settings.yml @adampoit')
$preservedCodeownersContent = @(
    $preservedCodeownersContent -split '\r?\n' |
        Where-Object { $_ -notin $managedCodeownerEntries }
) -join "`n"
$preservedCodeownersContent = $preservedCodeownersContent.TrimEnd()
$codeownersContent = if ($preservedCodeownersContent) {
    "$preservedCodeownersContent`n`n$managedCodeownersBlock`n"
} else {
    "$managedCodeownersBlock`n"
}

if ($existingCodeownersContent -eq $codeownersContent) {
    Write-Host "'$codeownersPath' already contains the published standard."
} else {
    [System.IO.File]::WriteAllText($codeownersPath, $codeownersContent, $utf8NoBom)
    $action = if ($existingCodeownersContent -eq '') { 'Created' } else { 'Updated' }
    Write-Host "$action '$codeownersPath'."
}
