# renovate

Installs a standard [Renovate](https://docs.renovatebot.com/) configuration for automated dependency updates.

## What it does

- Creates `renovate.json` with recommended defaults.
- Enables configured Renovate managers, merging with managers from existing configuration so multiple composites can contribute managers.
- Enables remediation PRs for GitHub vulnerability alerts.
- Opts into Renovate's beta Nix manager when `nix` is configured.
- Waits 5 days before proposing newly released dependency versions.
- Groups all non-major updates into a single PR while leaving major updates separate.
- Creates routine update branches before 7 AM on Tuesdays by default (`* 0-6 * * 2`).
- Enables the dependency dashboard by default.
- Applies the `automation` label by default.
- Removes `.github/dependabot.yml` so Renovate is the only dependency updater.

## Settings

| Setting               | Description                                                                                                                          | Default          |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `managers`            | Renovate managers to enable; merged with existing `enabledManagers` when present. Configuring `nix` also opts into its beta manager. | `github-actions` |
| `extends`             | Additional Renovate presets; merged with existing presets, `config:recommended`, and `:enableVulnerabilityAlerts`.                   | none             |
| `dependencyDashboard` | Whether to enable Renovate's dependency dashboard                                                                                    | `true`           |
| `labels`              | Labels to apply to Renovate PRs                                                                                                      | `automation`     |
| `schedule`            | Renovate schedule for routine branch creation.                                                                                       | `* 0-6 * * 2`    |
| `customManagers`      | Additional Renovate custom managers, such as regex. Adds `custom.regex` to `enabledManagers` automatically.                          | none             |
| `packageRules`        | Additional Renovate package rules; merged with the default non-major grouping rule.                                                  | none             |

## Usage

```yaml
conventions:
    - path: adampoit/conventions/renovate
      settings:
          managers:
              - github-actions
              - npm
```
