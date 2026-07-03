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

$managers = @('github-actions')
if ($settings -and $settings.PSObject.Properties['managers']) {
	$managers = @($settings.managers)
}
if ($settings -and $settings.PSObject.Properties['customManagers'] -and 'custom.regex' -notin $managers) {
	$managers += 'custom.regex'
}

$dependencyDashboard = $true
if ($settings -and $settings.PSObject.Properties['dependencyDashboard']) {
	$dependencyDashboard = [bool] $settings.dependencyDashboard
}

$labels = @('automation')
if ($settings -and $settings.PSObject.Properties['labels']) {
	$labels = @($settings.labels)
}

$config = [ordered] @{
	'$schema' = 'https://docs.renovatebot.com/renovate-schema.json'
	extends = @('config:recommended')
	dependencyDashboard = $dependencyDashboard
	labels = $labels
	enabledManagers = $managers
}

if ($settings -and $settings.PSObject.Properties['customManagers']) {
	$config.customManagers = @($settings.customManagers)
}

$configContent = $config | ConvertTo-Json -Depth 20

function Format-WithPrettier($content, $filePath) {
	$formatted = $content | & npx --yes prettier --stdin-filepath $filePath 2>$null | Out-String
	if ($LASTEXITCODE -eq 0 -and $formatted) {
		return $formatted
	}
	return $content
}

$configContent = Format-WithPrettier $configContent 'renovate.json'

$configPath = Join-Path $PWD 'renovate.json'
$existingContent = ''
if (Test-Path -LiteralPath $configPath -PathType Leaf) {
	$existingContent = Get-Content -LiteralPath $configPath -Raw
}

if ($existingContent -eq $configContent) {
	Write-Host "'$configPath' already matches the published standard."
} else {
	$utf8NoBom = New-Object System.Text.UTF8Encoding $false
	[System.IO.File]::WriteAllText($configPath, $configContent, $utf8NoBom)

	if ($existingContent -eq '') {
		Write-Host "Created '$configPath'."
	} else {
		Write-Host "Updated '$configPath'."
	}
}

$dependabotPath = Join-Path $PWD '.github/dependabot.yml'
if (Test-Path -LiteralPath $dependabotPath -PathType Leaf) {
	Remove-Item -LiteralPath $dependabotPath
	Write-Host "Removed '$dependabotPath'."
}
