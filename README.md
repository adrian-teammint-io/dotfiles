## Dotfiles, but make it cozy ✨

These are my dotfiles for a fast, clean, and low-friction macOS setup. Terminal-first, keyboard-forward, and minimal fluff — tuned for daily work without getting in the way.

### Highlights
- **fish**: speedy shell with sane defaults and clean prompt
- **Neovim (LazyVim)**: modern IDE vibes without the bloat
- **Ghostty**: beautiful, GPU-accelerated terminal with shader fun
- **Karabiner + skhd**: smart keys and global hotkeys
- **Zellij**: session + pane management when tmux feels heavy
- **oh-my-posh**: crisp prompt theming
- **Raycast**: a few custom extensions I actually use

---

### What’s inside
- `fish/`: shell config, functions, completions
- `nvim/`: Neovim config powered by LazyVim
- `ghostty/`: terminal config and GLSL shaders
- `karabiner/`: keymaps and automatic backups
- `skhd/`: hotkeys for global window mgmt
- `zellij/`: workspace/session layout
- `gh/`: GitHub CLI config
- `oh-my-posh/`: prompt themes
- `raycast/extensions/`: local Raycast extensions and assets
- `uv/`: Python `uv` integration for shell
- `bagels/`, `borders/`, `opencode/`, `reddittui/`: app/tool configs

---

### Quick start (macOS)
1) Install essentials
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install fish neovim zellij jq gh fd ripgrep uv
brew install --cask ghostty raycast karabiner-elements
```

2) Make fish your default shell
```bash
command -v fish | sudo tee -a /etc/shells
chsh -s (command -v fish)
```

3) Clone to the right place (if not already here)
```bash
mkdir -p ~/.config
git clone <this-repo> ~/.config
```

4) Launch things once
```bash
fish -lc 'true'         # triggers conf.d and env
nvim                     # LazyVim will auto-install plugins
open -a "Karabiner-Elements"  # enable the profile
```

---

### Notes per tool
- **fish**: environment lives in `fish/conf.d/`; prompt in `fish/functions/`; completions in `fish/completions/`.
- **Neovim**: configured via LazyVim; see `nvim/lua/plugins/custom.lua` for personal tweaks; formatters/linters are auto-detected when possible.
- **Ghostty**: config in `ghostty/config`; shaders in `ghostty/shaders/` — try the CRTs and gradients.
- **Karabiner**: main profile in `karabiner/karabiner.json`; automatic backups are under `karabiner/automatic_backups/`.
- **skhd**: keybinds in `skhd/skhdrc`; pairs well with your window manager of choice.
- **Zellij**: session defaults in `zellij/config.kdl`.
- **oh-my-posh**: themes live in `oh-my-posh/themes/`.
- **Raycast**: extensions are user-local; these folders reflect my custom scripts/assets.
- **uv**: Python toolchain integration via `fish/conf.d/uv.env.fish`.

---

### Syncing and updates
- Treat this repo like any other: edit configs → test → commit.
- For risky changes, copy the file to `*.bak` first (you’ll see a few in here already).
- New machine? Repeat Quick start and you’re set.

---

### FAQ
- “Why `~/.config` as the repo root?”
  Because macOS + modern tools respect XDG paths; fewer symlinks, less ceremony.

- “Can I cherry-pick just Neovim or fish?”
  Yes — copy the relevant folder(s) into your own `~/.config`.

- “Will this break my setup?”
  Unlikely, but always review diffs and back up before large changes.

---

### Credits
Inspired by countless dotfiles and plugin authors. You know who you are — thanks.



