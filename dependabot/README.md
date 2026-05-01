# dependabot

Installs a standard Dependabot configuration for automated dependency updates.

## Settings

- `ecosystems` (optional): Array of package ecosystems to enable. Defaults to `["github-actions"]`.
- `interval` (optional): Update interval. Defaults to `"weekly"`.
- `open-pull-requests-limit` (optional): Max open PRs per ecosystem. Defaults to `5`.

## Behavior

- Creates `.github/dependabot.yml` if it doesn't exist
- Overwrites existing file with the rendered configuration

## Example

```yaml
conventions:
  - path: adampoit/conventions/dependabot
    settings:
      ecosystems:
        - github-actions
        - npm
        - pip
      interval: daily
      open-pull-requests-limit: 10
```
