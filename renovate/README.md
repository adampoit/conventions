# renovate

Installs a standard [Renovate](https://docs.renovatebot.com/) configuration for automated dependency updates.

## What it does

- Creates `renovate.json` with recommended defaults.
- Enables only the configured Renovate managers.
- Enables the dependency dashboard by default.
- Applies the `automation` label by default.
- Removes `.github/dependabot.yml` so Renovate is the only dependency updater.

## Settings

| Setting               | Description                                                                                                 | Default          |
| --------------------- | ----------------------------------------------------------------------------------------------------------- | ---------------- |
| `managers`            | Renovate managers to enable                                                                                 | `github-actions` |
| `dependencyDashboard` | Whether to enable Renovate's dependency dashboard                                                           | `true`           |
| `labels`              | Labels to apply to Renovate PRs                                                                             | `automation`     |
| `customManagers`      | Additional Renovate custom managers, such as regex. Adds `custom.regex` to `enabledManagers` automatically. | none             |

## Usage

```yaml
conventions:
    - path: adampoit/conventions/renovate
      settings:
          managers:
              - github-actions
              - npm
```
