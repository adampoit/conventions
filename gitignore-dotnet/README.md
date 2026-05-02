# gitignore-dotnet

Ensures standard .NET entries are present in `.gitignore`.

## Settings

None.

## Behavior

- Creates `.gitignore` if it doesn't exist
- If `.gitignore` exists, appends any missing .NET entries (does not remove or modify existing entries)
- Skips entries that are already present

## Stacking

Works well alongside other additive gitignore conventions:

```yaml
conventions:
    - path: adampoit/conventions/gitignore-dotnet
    - path: adampoit/conventions/gitignore-node
```
