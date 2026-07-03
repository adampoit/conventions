# nix-project

Composite convention for Nix projects. Bundles formatting, gitignore, direnv, and optional licensing.

## Includes

| Convention                  | What it adds                                             |
| --------------------------- | -------------------------------------------------------- |
| `editorconfig`              | Standard `.editorconfig` from Faithlife/CodingGuidelines |
| `gitattributes`             | Standard `.gitattributes`                                |
| `gitignore-nix`             | Nix `.gitignore` entries (additive)                      |
| `nix-direnv`                | `.envrc` for nix-direnv auto-loading                     |
| `renovate`                  | Renovate for GitHub Actions + Nix                        |
| `repo-conventions-workflow` | GitHub Actions workflow to auto-update conventions       |
| `license-mit`               | Optional MIT license                                     |

Note: This composite intentionally does **not** include a `flake.nix` convention. Projects manage their own `flake.nix` since it's a code file that varies significantly per project.

## Settings

| Setting                    | Description                              | Default     |
| -------------------------- | ---------------------------------------- | ----------- |
| `license.enabled`          | Set to `false` to skip the MIT `LICENSE` | `true`      |
| `license.copyright-holder` | Name for MIT license                     | `Adam Poit` |

## Usage

```yaml
conventions:
    - path: adampoit/conventions/nix-project
      settings:
          license:
              enabled: false
```

When `license.enabled` is `true` or omitted, optionally set `license.copyright-holder` to override the default.
