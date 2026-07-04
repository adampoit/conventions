# dotnet-project

Composite convention for .NET projects. Bundles formatting, build settings, and dependency management.

## Includes

| Convention                  | What it adds                                                                           |
| --------------------------- | -------------------------------------------------------------------------------------- |
| `editorconfig`              | Standard `.editorconfig` from Faithlife/CodingGuidelines (tabs, tab-width 4, C# rules) |
| `gitattributes`             | Standard `.gitattributes`                                                              |
| `gitignore-dotnet`          | .NET `.gitignore` (additive)                                                           |
| `dotnet-sdk`                | `global.json` from Faithlife/CodingGuidelines                                          |
| `dotnet-slnx`               | Ensures `.slnx` solutions are used instead of `.sln`                                   |
| `dotnet-cpm`                | `Directory.Packages.props` for central package management                              |
| `nuget-config`              | `nuget.config` from Faithlife/CodingGuidelines                                         |
| `renovate`                  | Renovate for GitHub Actions + NuGet                                                    |
| `repo-conventions-workflow` | GitHub Actions workflow to auto-update conventions                                     |
| `license-mit`               | Optional MIT license                                                                   |

## Settings

| Setting                       | Description                                                             | Default     |
| ----------------------------- | ----------------------------------------------------------------------- | ----------- |
| `license.enabled`             | Set to `false` to skip the MIT `LICENSE`                                | `true`      |
| `license.copyright-holder`    | Name for MIT license                                                    | `Adam Poit` |
| `renovate.additionalManagers` | Extra Renovate managers to enable in addition to GitHub Actions + NuGet | none        |

Individual bundled conventions (`dotnet-sdk`) use their own documented defaults. If you need to customize those beyond the settings above, add the individual convention directly instead of using this composite.

## Usage

```yaml
conventions:
    - path: adampoit/conventions/dotnet-project
      settings:
          license:
              enabled: false
          renovate:
              additionalManagers:
                  - npm
                  - nix
```

When `license.enabled` is `true` or omitted, optionally set `license.copyright-holder` to override the default.
