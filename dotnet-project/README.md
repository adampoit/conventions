# dotnet-project

Composite convention for .NET projects. Bundles formatting, build settings, and dependency management.

## Includes

| Convention                  | What it adds                                                                           |
| --------------------------- | -------------------------------------------------------------------------------------- |
| `editorconfig`              | Standard `.editorconfig` from Faithlife/CodingGuidelines (tabs, tab-width 4, C# rules) |
| `gitattributes`             | Standard `.gitattributes`                                                              |
| `gitignore-dotnet`          | .NET `.gitignore` (additive)                                                           |
| `dotnet-sdk`                | `global.json` from Faithlife/CodingGuidelines                                          |
| `dotnet-cpm`                | `Directory.Packages.props` for central package management                              |
| `nuget-config`              | `nuget.config` from Faithlife/CodingGuidelines                                         |
| `repo-conventions-workflow` | GitHub Actions workflow to auto-update conventions                                     |
| `license-mit`               | MIT license from Faithlife/CodingGuidelines                                            |

## Settings

| Setting            | Description          | Default    |
| ------------------ | -------------------- | ---------- |
| `copyright-holder` | Name for MIT license | (required) |

Individual bundled conventions (`dotnet-sdk`) use their own documented defaults. If you need to customize those, add the individual convention directly instead of using this composite.

## Usage

```yaml
conventions:
    - path: adampoit/conventions/dotnet-project
      settings:
          copyright-holder: 'Adam Poit'
```
