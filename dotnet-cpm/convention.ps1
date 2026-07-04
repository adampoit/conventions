#requires -PSEdition Core
#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$cpmPath = Join-Path $PWD 'Directory.Packages.props'

if (-not (Test-Path -LiteralPath $cpmPath -PathType Leaf)) {
    $content = @"
<Project>
  <PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>
</Project>
"@
    Set-Content -LiteralPath $cpmPath -Value $content -Encoding utf8NoBOM -NoNewline
    Write-Host "Created '$cpmPath'."
    exit 0
}

$originalContent = Get-Content -LiteralPath $cpmPath -Raw
[xml] $document = $originalContent

$project = $document.DocumentElement
if ($null -eq $project -or $project.Name -ne 'Project') {
    throw "'$cpmPath' must have a Project root element."
}

$propertyGroups = @($project.ChildNodes | Where-Object { $_.NodeType -eq [System.Xml.XmlNodeType]::Element -and $_.Name -eq 'PropertyGroup' })
$propertyGroup = $propertyGroups | Where-Object { $null -ne $_.SelectSingleNode('ManagePackageVersionsCentrally') } | Select-Object -First 1
if ($null -eq $propertyGroup) {
    $propertyGroup = $propertyGroups | Select-Object -First 1
    if ($null -eq $propertyGroup) {
        $propertyGroup = $document.CreateElement('PropertyGroup')
        [void] $project.PrependChild($propertyGroup)
    }

    $property = $document.CreateElement('ManagePackageVersionsCentrally')
    $property.InnerText = 'true'
    [void] $propertyGroup.AppendChild($property)
} else {
    $propertyGroup.SelectSingleNode('ManagePackageVersionsCentrally').InnerText = 'true'
}

$stringBuilder = [System.Text.StringBuilder]::new()
$settings = [System.Xml.XmlWriterSettings]::new()
$settings.Encoding = [System.Text.UTF8Encoding]::new($false)
$settings.Indent = $true
$settings.OmitXmlDeclaration = $true
$settings.NewLineChars = "`n"

$writer = [System.Xml.XmlWriter]::Create($stringBuilder, $settings)
$document.Save($writer)
$writer.Dispose()

$updatedContent = $stringBuilder.ToString() + "`n"
if ($updatedContent -eq $originalContent) {
    Write-Host "'$cpmPath' already enables Central Package Management."
    exit 0
}

Set-Content -LiteralPath $cpmPath -Value $updatedContent -Encoding utf8NoBOM -NoNewline
Write-Host "Updated '$cpmPath'."
