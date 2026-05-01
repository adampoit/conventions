#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$envrcPath = Join-Path $PWD '.envrc'

$envrcContent = @"
if ! has nix_direnv_version || ! nix_direnv_version 3.0.6; then
  source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/3.0.6/direnvrc" "sha256-5sdxTPeW9KqKQ+aX6iEwJ3bJu2LZu6Y9xLhQkpg1E6g="
fi

use flake
"@

if (-not (Test-Path -LiteralPath $envrcPath -PathType Leaf)) {
    Set-Content -LiteralPath $envrcPath -Value $envrcContent -Encoding utf8NoBOM
    Write-Host "Created '$envrcPath'."
    exit 0
}

$existingContent = Get-Content -LiteralPath $envrcPath -Raw

if ($existingContent -match 'use flake') {
    Write-Host "'$envrcPath' already contains 'use flake'."
    exit 0
}

$combinedContent = $existingContent.TrimEnd("`r", "`n") + "`n`n# Added by nix-direnv convention`nuse flake`n"
Set-Content -LiteralPath $envrcPath -Value $combinedContent -Encoding utf8NoBOM
Write-Host "Updated '$envrcPath' with 'use flake'."
