# nix-direnv

Installs a `.envrc` for nix-direnv auto-loading.

## Settings

None.

## Behavior

- Creates `.envrc` if it doesn't exist
- Skips if `.envrc` already contains `use flake`
- Uses nix-direnv for faster flake evaluation

## Requirements

- [nix-direnv](https://github.com/nix-community/nix-direnv) must be installed and hooked into direnv
