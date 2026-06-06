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

function Get-Setting($name, $defaultValue) {
    if ($settings -and $settings.PSObject.Properties[$name] -and $null -ne $settings.$name) {
        return $settings.$name
    }
    return $defaultValue
}

$enabled = [bool](Get-Setting 'enabled' $true)
if (-not $enabled) {
    Write-Host 'MIT license convention is disabled by settings.'
    exit 0
}

$copyrightHolder = Get-Setting 'copyright-holder' 'Adam Poit'
$year = (Get-Date).Year
$licenseContent = @"
MIT License

Copyright (c) $year $copyrightHolder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@

$licensePath = Join-Path $PWD 'LICENSE'
$existingContent = ''
if (Test-Path -LiteralPath $licensePath -PathType Leaf) {
    $existingContent = Get-Content -LiteralPath $licensePath -Raw
}

if ($existingContent -eq $licenseContent) {
    Write-Host "'$licensePath' already matches the published standard."
    exit 0
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($licensePath, $licenseContent, $utf8NoBom)

if ($existingContent -eq '') {
    Write-Host "Created '$licensePath'."
} else {
    Write-Host "Updated '$licensePath'."
}
