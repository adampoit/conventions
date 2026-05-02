# tsconfig-node

Installs a `tsconfig.json` for Node.js TypeScript projects.

## Settings

- `target` (default: `"ES2022"`)
- `module` (default: `"NodeNext"`)
- `moduleResolution` (default: `"NodeNext"`)
- `outDir` (default: `"dist"`)
- `rootDir` (default: `"src"`)
- `strict` (default: `true`)
- `skipLibCheck` (default: `true`)
- `esModuleInterop` (default: `true`)
- `noEmitOnError` (default: `true`)

## Behavior

- Creates `tsconfig.json` if it doesn't exist
- Overwrites existing file with the configured settings

## Example

```yaml
conventions:
    - path: adampoit/conventions/tsconfig-node
      settings:
          target: ES2024
          outDir: build
          rootDir: lib
```
