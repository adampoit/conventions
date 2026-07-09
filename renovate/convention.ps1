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

$configPath = Join-Path $PWD 'renovate.json'
$existingContent = ''
$existingConfig = $null
if (Test-Path -LiteralPath $configPath -PathType Leaf) {
	$existingContent = Get-Content -LiteralPath $configPath -Raw
	if (-not [string]::IsNullOrWhiteSpace($existingContent)) {
		$existingConfig = $existingContent | ConvertFrom-Json
	}
}

if ($existingConfig -and $existingConfig.PSObject.Properties['enabledManagers']) {
	$managers = @($existingConfig.enabledManagers) + $managers
}
$managers = @($managers | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Select-Object -Unique)

$dependencyDashboard = $true
if ($existingConfig -and $existingConfig.PSObject.Properties['dependencyDashboard']) {
	$dependencyDashboard = [bool] $existingConfig.dependencyDashboard
}
if ($settings -and $settings.PSObject.Properties['dependencyDashboard']) {
	$dependencyDashboard = [bool] $settings.dependencyDashboard
}

$labels = @('automation')
if ($existingConfig -and $existingConfig.PSObject.Properties['labels']) {
	$labels = @($existingConfig.labels)
}
if ($settings -and $settings.PSObject.Properties['labels']) {
	$labels = @($labels) + @($settings.labels)
}
$labels = @($labels | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Select-Object -Unique)

$schedule = @('* 0-6 * * 2')
if ($existingConfig -and $existingConfig.PSObject.Properties['schedule']) {
	$schedule = @($existingConfig.schedule)
}
if ($settings -and $settings.PSObject.Properties['schedule']) {
	$schedule = @($settings.schedule)
}

$customManagers = @()
if ($existingConfig -and $existingConfig.PSObject.Properties['customManagers']) {
	$customManagers += @($existingConfig.customManagers)
}
if ($settings -and $settings.PSObject.Properties['customManagers']) {
	$customManagers += @($settings.customManagers)
}
$customManagers = @(
	$customManagers |
		Group-Object { $_ | ConvertTo-Json -Compress -Depth 20 } |
		ForEach-Object { $_.Group[0] }
)

$packageRules = @(
	[ordered] @{
		description = 'Group all non-major updates'
		matchUpdateTypes = @('minor', 'patch', 'pin', 'digest')
		groupName = 'all non-major dependencies'
	}
)
if ($existingConfig -and $existingConfig.PSObject.Properties['packageRules']) {
	$packageRules += @($existingConfig.packageRules)
}
if ($settings -and $settings.PSObject.Properties['packageRules']) {
	$packageRules += @($settings.packageRules)
}
$packageRules = @(
	$packageRules |
		Group-Object { $_ | ConvertTo-Json -Compress -Depth 20 } |
		ForEach-Object { $_.Group[0] }
)

$config = [ordered] @{
	'$schema' = 'https://docs.renovatebot.com/renovate-schema.json'
	extends = @('config:recommended')
	minimumReleaseAge = '5 days'
	internalChecksFilter = 'strict'
	dependencyDashboard = $dependencyDashboard
	labels = $labels
	schedule = $schedule
	enabledManagers = $managers
	packageRules = $packageRules
}

if ($customManagers.Count -gt 0) {
	$config.customManagers = $customManagers
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
