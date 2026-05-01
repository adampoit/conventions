# gitignore-nix

Ensures standard Nix entries are present in `.gitignore`.

## Settings

None.

## Behavior

- Creates `.gitignore` if it doesn't exist
- If `.gitignore` exists, appends any missing Nix entries (does not remove or modify existing entries)
- Skips entries that are already present

## Entries added

- `result` (Nix build output symlink)
- `result-*` (Multiple build outputs)
- `.direnv` (direnv cache)
