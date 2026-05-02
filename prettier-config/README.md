# prettier-config

Installs a `.prettierrc.json` file for consistent code formatting.

## Settings

- `semi` (default: `true`)
- `singleQuote` (default: `true`)
- `useTabs` (default: `true`)
- `tabWidth` (default: `4`)
- `trailingComma` (default: `"all"`)
- `printWidth` (default: `120`)

## Behavior

- Creates `.prettierrc.json` if it doesn't exist
- Overwrites existing file with the configured settings
- JSON and YAML files always use spaces with `tabWidth: 2` regardless of the global `useTabs` setting

## Example

```yaml
conventions:
    - path: adampoit/conventions/prettier-config
      settings:
          semi: true
          singleQuote: true
          useTabs: true
          tabWidth: 4
```
