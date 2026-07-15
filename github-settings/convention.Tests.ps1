#requires -PSEdition Core
#requires -Version 7.0

BeforeAll {
    $script:ConventionSourcePath = Join-Path $PSScriptRoot 'convention.ps1'
    $script:SettingsTemplate = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'files/settings.yml') -Raw

    function New-ConventionFixture {
        param(
            [AllowNull()]
            [string] $ExistingSettings,

            [string] $SettingsTemplate = $script:SettingsTemplate
        )

        $fixturePath = Join-Path $TestDrive ([guid]::NewGuid().ToString())
        $conventionPath = Join-Path $fixturePath 'convention'
        $workspacePath = Join-Path $fixturePath 'workspace'
        New-Item -ItemType Directory -Path (Join-Path $conventionPath 'files'), $workspacePath -Force | Out-Null
        Copy-Item -LiteralPath $script:ConventionSourcePath -Destination (Join-Path $conventionPath 'convention.ps1')
        [System.IO.File]::WriteAllText((Join-Path $conventionPath 'files/settings.yml'), $SettingsTemplate)
        [System.IO.File]::WriteAllText((Join-Path $conventionPath 'files/CODEOWNERS'), "# BEGIN github-settings convention`n# END github-settings convention`n")

        if ($null -ne $ExistingSettings) {
            $githubPath = Join-Path $workspacePath '.github'
            New-Item -ItemType Directory -Path $githubPath -Force | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $githubPath 'settings.yml'), $ExistingSettings)
        }

        return @{
            ConventionPath = Join-Path $conventionPath 'convention.ps1'
            SettingsPath = Join-Path $workspacePath '.github/settings.yml'
            WorkspacePath = $workspacePath
        }
    }

    function Invoke-ConventionFixture {
        param([hashtable] $Fixture)

        Push-Location $Fixture.WorkspacePath
        try {
            & $Fixture.ConventionPath
        } finally {
            Pop-Location
        }
    }
}

Describe 'github-settings required status check preservation' {
    It 'preserves a single required_status_checks rule and its parameters' {
        $existingSettings = @'
rulesets:
  - rules:
      - type: required_status_checks
        parameters:
          strict_required_status_checks_policy: true
          required_status_checks:
            - context: test
              integration_id: 123
      - type: pull_request
'@
        $fixture = New-ConventionFixture -ExistingSettings $existingSettings

        Invoke-ConventionFixture $fixture

        $actual = Get-Content -LiteralPath $fixture.SettingsPath -Raw
        $actual | Should -Match '(?ms)# Project-specific required status checks.*?      - type: required_status_checks\n        parameters:\n          strict_required_status_checks_policy: true\n          required_status_checks:\n            - context: test\n              integration_id: 123\n      - type: pull_request'
    }

    It 'preserves multiple required_status_checks rules' {
        $existingSettings = @'
rulesets:
  - rules:
      - type: required_status_checks
        parameters:
          required_status_checks:
            - context: build
      - type: pull_request
  - rules:
      - type: required_status_checks # preserve this rule too
        parameters:
          required_status_checks:
            - context: lint
'@
        $fixture = New-ConventionFixture -ExistingSettings $existingSettings

        Invoke-ConventionFixture $fixture

        $actual = Get-Content -LiteralPath $fixture.SettingsPath -Raw
        ([regex]::Matches($actual, '(?m)^\s*- type: required_status_checks(?:\s+#.*)?$')).Count | Should -Be 2
        $actual | Should -Match '(?m)^\s*- context: build$'
        $actual | Should -Match '(?m)^\s*- context: lint$'
    }

    It 'uses the template when the existing file has no required_status_checks rules' {
        $fixture = New-ConventionFixture -ExistingSettings "rulesets:`n  - rules:`n      - type: pull_request`n"

        Invoke-ConventionFixture $fixture

        (Get-Content -LiteralPath $fixture.SettingsPath -Raw) | Should -BeExactly $script:SettingsTemplate
    }

    It 'removes trailing blank lines from a preserved rule' {
        $existingSettings = "rulesets:`n  - rules:`n      - type: required_status_checks`n        parameters:`n          required_status_checks: []`n        `n`n      - type: pull_request`n"
        $fixture = New-ConventionFixture -ExistingSettings $existingSettings

        Invoke-ConventionFixture $fixture

        $actual = Get-Content -LiteralPath $fixture.SettingsPath -Raw
        $actual | Should -Match 'required_status_checks: \[\]\n      - type: pull_request'
        $actual | Should -Not -Match 'required_status_checks: \[\]\n\s*\n\s*\n      - type: pull_request'
    }

    It 'uses the template when the existing file is empty' {
        $fixture = New-ConventionFixture -ExistingSettings ''

        Invoke-ConventionFixture $fixture

        (Get-Content -LiteralPath $fixture.SettingsPath -Raw) | Should -BeExactly $script:SettingsTemplate
    }

    It 'creates settings from the template when no existing file is present' {
        $fixture = New-ConventionFixture -ExistingSettings $null

        Invoke-ConventionFixture $fixture

        (Get-Content -LiteralPath $fixture.SettingsPath -Raw) | Should -BeExactly $script:SettingsTemplate
    }

    It 'throws when preservation is needed but the template marker is absent' {
        $existingSettings = "rulesets:`n  - rules:`n      - type: required_status_checks`n        parameters: {}`n"
        $templateWithoutMarker = $script:SettingsTemplate.Replace("      # Project-specific required status checks are preserved below this line.`n", '')
        $fixture = New-ConventionFixture -ExistingSettings $existingSettings -SettingsTemplate $templateWithoutMarker

        { Invoke-ConventionFixture $fixture } | Should -Throw '*missing the required status check insertion marker*'
    }

    It 'is idempotent when applied twice' {
        $existingSettings = "rulesets:`n  - rules:`n      - type: required_status_checks`n        parameters:`n          required_status_checks:`n            - context: test`n"
        $fixture = New-ConventionFixture -ExistingSettings $existingSettings

        Invoke-ConventionFixture $fixture
        $firstResult = Get-Content -LiteralPath $fixture.SettingsPath -Raw
        Invoke-ConventionFixture $fixture
        $secondResult = Get-Content -LiteralPath $fixture.SettingsPath -Raw

        $secondResult | Should -BeExactly $firstResult
        ([regex]::Matches($secondResult, '(?m)^\s*- type: required_status_checks$')).Count | Should -Be 1
    }
}
