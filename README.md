# Conventions

Shared repository conventions applied using [RepoConventions](https://github.com/Faithlife/RepoConventions).

## Usage

Install RepoConventions:

```pwsh
dotnet tool install --global repo-conventions
```

In a target repository, add conventions from this repo. The easiest way is to use a **composite convention** that bundles everything:

```pwsh
# TypeScript/Node.js
repo-conventions add adampoit/conventions/typescript-project

# .NET
repo-conventions add adampoit/conventions/dotnet-project

# Nix
repo-conventions add adampoit/conventions/nix-project
```

Or add individual conventions:

```pwsh
repo-conventions add Faithlife/CodingGuidelines/conventions/editorconfig-root
repo-conventions add adampoit/conventions/gitattributes
repo-conventions add Faithlife/CodingGuidelines/conventions/license-mit
repo-conventions add Faithlife/CodingGuidelines/conventions/repo-conventions-workflow
```

Then apply them:

```pwsh
repo-conventions apply
```

Or add and apply in one step with a PR:

```pwsh
repo-conventions add Faithlife/CodingGuidelines/conventions/editorconfig-root --open-pr
```

## Available Conventions

### Composites

| Convention | Description |
|------------|-------------|
| [`typescript-project`](typescript-project) | TypeScript/Node.js project setup (editorconfig, prettierignore, license from Faithlife; gitattributes, gitignore, prettier, tsconfig, dependabot) |
| [`dotnet-project`](dotnet-project) | .NET project setup (editorconfig, dotnet SDK, nuget-config, license from Faithlife; gitattributes, gitignore, CPM) |
| [`nix-project`](nix-project) | Nix project setup (editorconfig, license from Faithlife; gitattributes, gitignore, direnv) |

### Individual

| Convention | Description |
|------------|-------------|
| [`gitattributes`](gitattributes) | Standard `.gitattributes` for line endings and diffs |
| [`gitignore-node`](gitignore-node) | Node.js `.gitignore` (additive — merges with existing) |
| [`gitignore-dotnet`](gitignore-dotnet) | .NET `.gitignore` (additive — merges with existing) |
| [`prettier-config`](prettier-config) | `.prettierrc.json` with configurable rules |
| [`tsconfig-node`](tsconfig-node) | `tsconfig.json` for Node.js TypeScript projects |
| [`dotnet-cpm`](dotnet-cpm) | Central Package Management (`Directory.Packages.props`) |
| [`nix-direnv`](nix-direnv) | `.envrc` for nix-direnv auto-loading |
| [`gitignore-nix`](gitignore-nix) | Nix `.gitignore` entries (additive) |
| [`dependabot`](dependabot) | Dependabot configuration for automated dependency updates |

## Authoring Conventions

Each convention lives in its own directory at the repo root and contains:

- `convention.ps1` — PowerShell script that inspects/modifies the target repo
- `README.md` — Documentation for what the convention does and which settings it accepts
- Supporting files (templates, text files, etc.)

### Composite Conventions

Composites bundle multiple conventions using `convention.yml` instead of `convention.ps1`:

```yaml
conventions:
  - path: Faithlife/CodingGuidelines/conventions/editorconfig-root
  - path: ../prettier-config
    settings:
      semi: ${{ settings.prettier.semi }}
  - path: Faithlife/CodingGuidelines/conventions/license-mit
    settings:
      copyright-holder: ${{ settings.copyright-holder }}
```

See the [`typescript-project`](typescript-project) convention for a full example, and the [RepoConventions authoring guide](https://github.com/Faithlife/RepoConventions/blob/master/docs/authoring-conventions.md) for details.
