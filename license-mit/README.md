# MIT License

Creates or updates `LICENSE` with an MIT license.

## Settings

| Setting            | Default     | Description                                         |
| ------------------ | ----------- | --------------------------------------------------- |
| `enabled`          | `true`      | Set to `false` to skip creating/updating `LICENSE`. |
| `copyright-holder` | `Adam Poit` | Copyright holder written into the license.          |

Composite project conventions expose this through `license.enabled`:

```yaml
settings:
    license:
        enabled: false
```
