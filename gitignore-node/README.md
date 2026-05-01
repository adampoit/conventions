# gitignore-node

Ensures standard Node.js entries are present in `.gitignore`.

## Settings

None.

## Behavior

- Creates `.gitignore` if it doesn't exist
- If `.gitignore` exists, appends any missing Node.js entries (does not remove or modify existing entries)
- Skips entries that are already present
