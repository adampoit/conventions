# nix-project

Composite convention for Nix projects. Bundles formatting, gitignore, direnv, and licensing.

## Includes

| Convention | What it adds |
|------------|-------------|
| `editorconfig` | Standard `.editorconfig` from Faithlife/CodingGuidelines |
| `gitattributes` | Standard `.gitattributes` |
| `gitignore-nix` | Nix `.gitignore` entries (additive) |
| `nix-direnv` | `.envrc` for nix-direnv auto-loading |
| `repo-conventions-workflow` | GitHub Actions workflow to auto-update conventions |
| `license-mit` | MIT license from Faithlife/CodingGuidelines |

Note: This composite intentionally does **not** include a `flake.nix` convention. Projects manage their own `flake.nix` since it's a code file that varies significantly per project.

## Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `copyright-holder` | Name for MIT license | (required) |

## Usage

```yaml
conventions:
  - path: adampoit/conventions/nix-project
    settings:
      copyright-holder: "Adam Poit"
```
