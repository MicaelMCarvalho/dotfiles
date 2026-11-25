# macOS dotfiles

Personal configuration for Zsh, Git, WezTerm, iTerm2, and Karabiner-Elements, plus
scripts for restoring monitor layouts.

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
- A `Brewfile` containing the main dependencies.
- An optional `Brewfile.apps` for desktop apps and Karabiner shortcuts.

## Install

These files target macOS. Review them before installing because the Git identity
and monitor IDs are personal.

Install [Homebrew](https://brew.sh/) first. `install.sh` installs Oh My Zsh,
Powerlevel10k, fzf-tab, and NVM if they are missing.

```sh
git clone git@github.com:MicaelMCarvalho/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles

# Preview dependency installs and link operations.
./install.sh --dry-run

# Install dependencies and create the links.
brew bundle
./install.sh
```

For the optional desktop apps, sign in to the Mac App Store with the Apple
Account that owns Magnet, then run `brew bundle --file=Brewfile.apps`.
The Obsidian shortcut expects a vault named `Diary`. Set up Tasks separately at
`~/Applications/Tasks.app` and install Slack if you use its shortcut.

Open a new shell after installing. Run `nvm install --lts` if you need a default
Node.js version, or run `nvm install` from a project with an `.nvmrc`.
Zsh loads fzf integration from the Homebrew binary on a fresh setup and uses the
bundled shell integration when running inside iTerm2.

Existing destination files are never deleted. The installer moves conflicts to
a timestamped directory under `~/.dotfiles-backup/`, and it leaves correct
links untouched when run again.

The installer manages:

| Repository file | Destination |
| --- | --- |
| `git/.gitconfig` | `~/.gitconfig` |
| `git/.gitconfig-work` | `~/.gitconfig-work` |
| `git/.gitignore_global` | `~/.gitignore_global` |
| `wezterm/.wezterm.lua` | `~/.wezterm.lua` |
| `iterm2/wezterm-like.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/wezterm-like.json` |
| `zsh/.zprofile` | `~/.zprofile` |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `zsh/.aliases` | `~/.aliases` |
| `zsh/.fzcmd_descriptions.zsh` | `~/.fzcmd_descriptions.zsh` |
| `nvim/` | `~/.config/nvim` |
| `karabiner/` | `~/.config/karabiner` |
| `gh/config.yml` | `~/.config/gh/config.yml` (or the configured GitHub CLI directory) |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |

Karabiner's generated automatic backups are ignored. Because its entire config
directory is linked, changes made in Karabiner-Elements are reflected directly
in this repository.

## Local and secret configuration

Sign in with `gh auth login` on a new machine. GitHub CLI authentication and
SSH private keys are stored separately from these dotfiles. Configure a custom
Flutter SDK path in VS Code workspace settings if your project needs one.

Put machine-only settings, secrets, or experimental configuration in
`~/.zshrc.local`. It is sourced last and is deliberately not managed by this
repository.

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
| `fzgit` | Select a tracked Git file |
| `fzconf` | Select a file below `~/.config` |
| `fzh` | Search shell history |
| `fzcmd` | Browse available commands and descriptions |
| `mdview FILE` | Render a Markdown file in the terminal with Glow |

## WezTerm leader keys

The leader is `Ctrl-a`.

| Key | Action |
| --- | --- |
| `s` / `v` | Split vertically / horizontally |
| `h j k l` | Move between panes |
| `r` | Enter pane resize mode |
| `t` | Create a tab after the current tab |
| `[` / `]` | Select previous / next tab |
| `m` | Enter tab move mode |
| `w` | Select a workspace |
| `b` | Toggle background opacity |
| `?` | Open the fuzzy keybinding menu |

## iTerm2 leader keys

The installer makes the `WezTerm-like` dynamic profile the iTerm2 default and
sets the same `Ctrl-a` leader. Its pane, tab, navigation, Dracula color, opacity,
scrollback, and close-confirmation settings track the WezTerm configuration.
`Control-Shift-Arrow` moves focus between panes without using the leader.
See [`iterm2/README.md`](iterm2/README.md) for the mappings and the few native
iTerm2 substitutions.

## Karabiner mappings

- `Caps Lock` held: Hyper modifier (`Control-Option-Shift-Command`).
- `Caps Lock` tapped: Caps Lock.
- `F5`: toggle microphone input mute and play an audio cue.
- `Left Command-Left Option`: Globe/Fn key.
- `Option-Tab` / `Shift-Option-Tab`: cycle forward/backward through windows of
  the current application.
- Hyper plus a configured letter: open the corresponding application.

## Validate

```sh
./scripts/check.sh
```

The checker always performs Bash, Zsh, JSON, and iTerm2 profile checks. It also
runs ShellCheck and WezTerm validation when those programs are installed.
