# typescript-project

Composite convention for TypeScript/Node.js projects. Bundles formatting, tooling, and dependency management conventions commonly used by projects like [patchlane](https://github.com/adampoit/patchlane).

## Includes

| Convention | What it adds |
|------------|-------------|
| `editorconfig` | Standard `.editorconfig` from Faithlife/CodingGuidelines |
| `gitattributes` | Standard `.gitattributes` |
| `gitignore-node` | Node.js `.gitignore` |
| `prettier-config` | `.prettierrc.json` (tabs, single quotes, trailing commas, 120 width) |
| `prettierignore-section` | `.prettierignore` from Faithlife/CodingGuidelines (when Prettier detected) |
| `tsconfig-node` | `tsconfig.json` for Node.js (ES2022, NodeNext, strict) |
| `dependabot` | Dependabot for GitHub Actions + npm (weekly) |
| `license-mit` | MIT license from Faithlife/CodingGuidelines |

Note: This composite intentionally does **not** include a CI workflow. Projects manage their own GitHub Actions workflows.

## Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `copyright-holder` | Name for MIT license | (required) |

## Usage

```yaml
conventions:
  - path: adampoit/conventions/typescript-project
    settings:
      copyright-holder: "Adam Poit"
```
