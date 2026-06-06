# typescript-project

Composite convention for TypeScript/Node.js projects. Bundles formatting, tooling, and dependency management conventions commonly used by projects like [patchlane](https://github.com/adampoit/patchlane).

## Includes

| Convention                  | What it adds                                                               |
| --------------------------- | -------------------------------------------------------------------------- |
| `editorconfig`              | Standard `.editorconfig` from Faithlife/CodingGuidelines                   |
| `gitattributes`             | Standard `.gitattributes`                                                  |
| `gitignore-node`            | Node.js `.gitignore`                                                       |
| `prettier-config`           | `.prettierrc.json` (tabs, single quotes, trailing commas, 120 width)       |
| `prettierignore-section`    | `.prettierignore` from Faithlife/CodingGuidelines (when Prettier detected) |
| `tsconfig-node`             | `tsconfig.json` for Node.js (ES2022, NodeNext, strict)                     |
| `dependabot`                | Dependabot for GitHub Actions + npm (weekly)                               |
| `repo-conventions-workflow` | GitHub Actions workflow to auto-update conventions                         |
| `license-mit`               | Optional MIT license                                                       |

## Settings

| Setting                    | Description                              | Default     |
| -------------------------- | ---------------------------------------- | ----------- |
| `license.enabled`          | Set to `false` to skip the MIT `LICENSE` | `true`      |
| `license.copyright-holder` | Name for MIT license                     | `Adam Poit` |

## Usage

```yaml
conventions:
    - path: adampoit/conventions/typescript-project
      settings:
          license:
              enabled: false
```

When `license.enabled` is `true` or omitted, optionally set `license.copyright-holder` to override the default.
