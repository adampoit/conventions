#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$workflowPath = Join-Path $PWD '.github/workflows/repo-conventions.yml'
$existingWorkflowContent = $null
$existingMinute = $null
$checkoutAction = 'actions/checkout@v4'
$setupDotnetAction = 'actions/setup-dotnet@v4'
if (Test-Path -LiteralPath $workflowPath) {
	$existingWorkflowContent = Get-Content -LiteralPath $workflowPath -Raw
	if ($existingWorkflowContent -match '(?m)^\s+- cron: [''"\"](?<minute>([0-9]|[1-5][0-9])) 9 \* \* 1-5[''"\"]\r?$') {
		$existingMinute = $Matches.minute
	}
	if ($existingWorkflowContent -match '(?m)^\s+uses: (?<action>actions/checkout@\S+)\r?$') {
		$checkoutAction = $Matches.action
	}
	if ($existingWorkflowContent -match '(?m)^\s+uses: (?<action>actions/setup-dotnet@\S+)\r?$') {
		$setupDotnetAction = $Matches.action
	}
}

$workflowDirectory = Split-Path -Parent $workflowPath
New-Item -ItemType Directory -Path $workflowDirectory -Force | Out-Null

$minute = if ($null -ne $existingMinute) {
	$existingMinute
} else {
	Get-Random -Minimum 1 -Maximum 60
}

$workflowContent = @"
name: Apply Repository Conventions

on:
  schedule:
    - cron: '$minute 9 * * 1-5'
  workflow_dispatch:
    inputs:
      conventions:
        type: string
        description: Optional convention names to add (space-separated)
        required: false
        default: ''

permissions:
  contents: write
  pull-requests: write

jobs:
  apply:
    runs-on: ubuntu-latest
    env:
      GH_TOKEN: `${{ secrets.ACTIONS_PAT }}
    steps:
      - name: Checkout
        uses: $checkoutAction
        with:
          token: `${{ secrets.ACTIONS_PAT }}

      - name: Setup .NET
        uses: $setupDotnetAction
        with:
          dotnet-version: 10.0.x

      - name: Configure Git identity
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

      - name: Add requested conventions
        if: `${{ github.event_name == 'workflow_dispatch' && inputs.conventions != '' }}
        run: dnx repo-conventions add `${{ inputs.conventions }} --commit

      - name: Apply conventions
        run: dnx repo-conventions apply --open-pr
"@

function Format-WithPrettier($content, $filePath) {
	$formatted = $content | & npx --yes prettier --stdin-filepath $filePath 2>$null | Out-String
	if ($LASTEXITCODE -eq 0 -and $formatted) {
		return $formatted
	}
	return $content
}

$workflowContent = Format-WithPrettier $workflowContent '.github/workflows/repo-conventions.yml'

$normalizedWorkflowContent = $workflowContent.Replace("`r`n", "`n").TrimEnd("`n")
if ($null -ne $existingWorkflowContent) {
	$normalizedExistingWorkflowContent = $existingWorkflowContent.Replace("`r`n", "`n").TrimEnd("`n")
	if ($normalizedExistingWorkflowContent -eq $normalizedWorkflowContent) {
		Write-Host 'Workflow already up to date.'
		exit 0
	}
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($workflowPath, $workflowContent, $utf8NoBom)
Write-Host "Updated $workflowPath"
