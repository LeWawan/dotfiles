# coolercontrol

This stow package targets `/` (system root), NOT `$HOME`.

It manages system-level configs in `/etc/coolercontrol/`.

## Usage

**Do NOT run `stow coolercontrol` directly** — it will create broken symlinks in `$HOME`.

Use the installer or stow manually with:

```bash
sudo stow -t / coolercontrol      # install
sudo stow -t / -D coolercontrol   # uninstall
```

This is handled automatically by `bin/core/setup-env`.
