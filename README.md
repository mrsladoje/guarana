# ☕ guarana

Keep your Mac wide awake — so you can close the lid, drop it in your bag, and walk away while it keeps running (downloads, builds, servers, syncs, you name it).

<img width="839" height="304" alt="Screenshot 2026-05-30 at 2 49 44 PM" src="https://github.com/user-attachments/assets/269071d1-d1de-4059-b61d-bba36e56480f" />


`guarana` runs [`caffeinate`](https://ss64.com/mac/caffeinate.html) and disables lid sleep via `pmset`, so your machine won't sleep even with the lid shut. One command to start, one to stop.


```
guarana          # stay awake — safe to close the lid and bag it
guarana --kill   # back to normal sleep
```

## Install

One command — paste it into your terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/mrsladoje/guarana/main/install.sh | bash
```

That installs the `guarana` command to `/usr/local/bin` (already on the default macOS `PATH`), so it works in **any** shell — zsh, bash, fish — no config edits required.

### Prefer not to pipe to bash?

Drop the script straight onto your `PATH`:

```sh
sudo curl -fsSL https://raw.githubusercontent.com/mrsladoje/guarana/main/guarana -o /usr/local/bin/guarana
sudo chmod +x /usr/local/bin/guarana
```

### From a clone

```sh
git clone https://github.com/mrsladoje/guarana.git
cd guarana
./install.sh
```

## Usage

| Command           | What it does                                                                      |
| ----------------- | --------------------------------------------------------------------------------- |
| `guarana`         | Keeps the Mac awake (`caffeinate -dis`) **and** disables lid sleep.               |
| `guarana --nolid` | Keeps the Mac awake but leaves lid sleep **on** — no `sudo` needed. (alias: `-n`) |
| `guarana --kill`  | Stops caffeinate and re-enables normal lid sleep. (alias: `-k`)                   |
| `guarana --help`  | Show usage. (alias: `-h`)                                                          |

`caffeinate` is started detached, so it keeps running after you close the terminal — close the lid and bag it. `guarana --kill` cleans everything back up.

Use **`--nolid`** when you just want the Mac to stay awake while you're using it (or on an external display) and you're fine with it sleeping when the lid closes. It skips `pmset`, so it won't ask for your password.

> **Note:** disabling lid sleep uses `pmset`, which needs admin rights, so plain `guarana` will ask for your password (via `sudo`). `guarana --nolid` skips that. Nothing else leaves your machine.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/mrsladoje/guarana/main/uninstall.sh | bash
```

This restores normal sleep settings and removes the command.

## How it works

- **`caffeinate -dis`** prevents idle, display, and system sleep while it runs.
- **`pmset -b/-c disablesleep 1`** disables sleep-on-lid-close for both battery and charger.
- `guarana --kill` reverses both: `killall caffeinate` + `pmset … disablesleep 0`.

macOS only (it relies on `caffeinate` and `pmset`).

## License

MIT — see [LICENSE](LICENSE).
