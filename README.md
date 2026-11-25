# macOS dotfiles

Personal macOS setup for Zsh and Powerlevel10k, WezTerm and iTerm2, Git and
GitHub CLI, Neovim, VS Code, and Karabiner-Elements.

## What is included

- A guarded Zsh setup with Oh My Zsh, Powerlevel10k, fzf helpers, lazy NVM
  loading, shared history, aliases, and optional local overrides.
- Git defaults for pruning, fast-forward-only pulls, automatic upstream setup,
  rerere, and a separate identity for repositories under `~/cleanslate/`.
- A WezTerm configuration with pane, tab, workspace, resize, and fuzzy
  keybinding controls.
- An iTerm2 dynamic profile with matching colors, navigation, and leader keys.
- A Karabiner-Elements profile with a Caps Lock Hyper key, application
  shortcuts, Globe-key mapping, and an F5 microphone toggle.
- `displayplacer` scripts for the author's side-by-side and vertical monitor
  layouts.
- A [Brewfile](Brewfile) for the shell, terminals, and CLI tools, including
  `codex`, `claude` (Claude Code), and `gcloud`.
- An optional [desktop bundle](Brewfile.apps) with Raycast, Magnet, Proton VPN,
  Docker Desktop, and apps launched by Karabiner shortcuts. The Claude desktop
  app is in this bundle.

## Install

Install [Homebrew](https://brew.sh/) and clone the repo to a location you plan
to keep. The installer creates symlinks to that checkout. Review the identities
in [`.gitconfig`](git/.gitconfig) and [`.gitconfig-work`](git/.gitconfig-work)
before linking them. The work identity applies under `~/cleanslate/`.

```sh
git clone git@github.com:MicaelMCarvalho/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles

# Preview dependency installs and link operations.
./install.sh --dry-run

# Install dependencies and create the links.
brew bundle
./install.sh
```

### Optional desktop apps

Sign in to the Mac App Store with the Apple Account that owns Magnet, then run:

```sh
brew bundle --file=Brewfile.apps
```

The bundle installs apps. Use the apps' own sign-in, import, and permission
prompts to restore accounts and settings. The Obsidian shortcut expects a vault
named `Diary`. Set up `~/Applications/Tasks.app` and Slack separately if you use
their shortcuts.

### First launch

- Open a new shell and restart iTerm2. The installer fetches Oh My Zsh,
  Powerlevel10k, `fzf-tab`, and NVM when missing. The linked `.p10k.zsh` restores
  the prompt layout without running `p10k configure`.
- Run `nvm install --lts` for a default Node.js version, or run `nvm install`
  from a project with an `.nvmrc`.
- Run `gh auth login` if you use GitHub CLI. Start `codex` and `claude` to set up
  each CLI account.
- Open Karabiner-Elements and grant the macOS permissions it requests, then
  test the Hyper key and window cycling.

## Managed files and backups

The installer moves conflicting files to a timestamped directory under
`~/.dotfiles-backup/`. Set `DOTFILES_BACKUP_DIR` to choose a different backup
root. A repeat run keeps correct symlinks in place and reapplies the iTerm2
preferences. To restore a backed-up file, remove its symlink and move the
corresponding file from the backup directory to its original location. The
backup covers replaced files. iTerm2 preferences written via `defaults` are
stored by macOS separately.

The installer manages these paths:

- Files in [`git/`](git/) and [`zsh/`](zsh/) are linked by name in `~`.
- [`wezterm/.wezterm.lua`](wezterm/.wezterm.lua) goes to `~/.wezterm.lua`.
- [`iterm2/wezterm-like.json`](iterm2/wezterm-like.json) goes into
  `~/Library/Application Support/iTerm2/DynamicProfiles/`.
- [`nvim/`](nvim/) and [`karabiner/`](karabiner/) go into `~/.config/`.
- [`gh/config.yml`](gh/config.yml) goes to `~/.config/gh/config.yml` by
  default. The installer honors `GH_CONFIG_DIR` and `XDG_CONFIG_HOME`.
- [`vscode/settings.json`](vscode/settings.json) goes into
  `~/Library/Application Support/Code/User/`.

Karabiner's generated automatic backups are ignored. Because its entire config
directory is linked, changes made in Karabiner-Elements are reflected directly
in this repository.

## Local and secret configuration

Keep GitHub CLI authentication and SSH private keys outside the checkout. Set
a custom Flutter SDK path in VS Code workspace settings if your project needs one.

Put machine-only settings, secrets, or experimental configuration in
`~/.zshrc.local`. Zsh loads it near the end of startup, before the standalone
syntax-highlighting fallback.

The `voluntinder-mock` helper reads its secret from macOS Keychain. Override
the default `~/git/vost` project location with `VOST_ROOT`:

```sh
export VOST_ROOT="$HOME/src/vost"
```

## Useful shell commands

| Command | Purpose |
| --- | --- |
| `fzne` | Find a file and open it in Neovim |
| `fznea` | Find a file, including ignored files |
| `fzcd` | Find and enter a directory |
| `ffcd` | Find a file and enter its directory |
| `fzrg PATTERN` | Search file contents and open the selected match |
| `fzgit` | Open a tracked Git file in Neovim |
| `fzconf` | Open a file below `~/.config` in Neovim |
| `fzh` | Search shell history and insert a command for editing |
| `fzcmd` | Browse available commands and insert one at the prompt |
| `mdview FILE` | Render a Markdown file in the terminal with Glow |

## WezTerm leader keys

Press `Ctrl-a`, then the key below.

| Key | Action |
| --- | --- |
| `s` / `v` | Split into top and bottom / left and right panes |
| `h j k l` | Focus the pane to the left, below, above, or right |
| `q` / `z` | Close with confirmation / toggle pane zoom |
| `r` | Resize with `h j k l`, then press `Enter` or `Esc` to exit |
| `t` | Create a tab after the current tab |
| `[` / `]` | Select previous / next tab |
| `n` / `1`–`9` | Open the tab navigator / select a tab by number |
| `m` | Move tabs with `h` or `l`, then press `Enter` or `Esc` to exit |
| `w` | Select a workspace |
| `b` | Toggle background opacity |
| `?` | Open the fuzzy keybinding menu |

## iTerm2 leader keys

The installer makes `WezTerm-like` the default iTerm2 profile. It shares the
`Ctrl-a` leader and common pane and tab shortcuts with WezTerm. The
[iTerm2 guide](iterm2/README.md) lists the full mappings and how to check the
profile after installation.

## Karabiner mappings

- `Caps Lock` held: Hyper modifier (`Control-Option-Shift-Command`).
- `Caps Lock` tapped: Caps Lock.
- Double-tap `Right Option`: toggle Caps Lock.
- `F5`: toggle microphone input mute and play an audio cue.
- `Left Command-Left Option`: Globe/Fn key.
- `Option-Tab` / `Shift-Option-Tab`: cycle forward/backward through windows of
  the current application.
- Hyper plus a configured letter: open the corresponding application.

## Monitor layouts

The [side-by-side](scripts/monitors_position_macos/displays-side-by-side.sh) and
[vertical](scripts/monitors_position_macos/displays-vertical.sh) presets use
display IDs and coordinates specific to the author's setup. On a different
Mac, run `displayplacer list` and update the preset for your displays before
running it.

## Validate

```sh
./scripts/check.sh
```

The checker validates shell syntax, Karabiner and iTerm2 JSON, VS Code settings,
and unstaged diff whitespace. It also runs ShellCheck and WezTerm validation
when those programs are installed. Use `./install.sh --dry-run` to preview
dependency downloads, symlinks, backups, and iTerm2 preference writes.
