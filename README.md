# macOS dotfiles

Personal configuration for Zsh, Git, and WezTerm, plus scripts for restoring
monitor layouts.

## What is included

- A guarded Zsh setup with Oh My Zsh, Powerlevel10k, fzf helpers, lazy NVM
  loading, shared history, aliases, and optional local overrides.
- Git defaults for pruning, fast-forward-only pulls, automatic upstream setup,
  rerere, and a separate identity for repositories under `~/cleanslate/`.
- A WezTerm configuration with pane, tab, workspace, resize, and fuzzy
  keybinding controls.
- `displayplacer` scripts for the author's side-by-side and vertical monitor
  layouts.
- A `Brewfile` containing the main dependencies.

## Install

These files target macOS. Review them before installing because the Git identity
and monitor IDs are personal.

Install [Homebrew](https://brew.sh/) and
[Oh My Zsh](https://ohmyz.sh/) first. Powerlevel10k is optional; when it is not
installed, Zsh still loads normally without the custom prompt.

```sh
git clone git@github.com:MicaelMCarvalho/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles

# Preview every link operation.
./install.sh --dry-run

# Install dependencies and create the links.
brew bundle
./install.sh
```

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
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.aliases` | `~/.aliases` |
| `zsh/.fzcmd_descriptions.zsh` | `~/.fzcmd_descriptions.zsh` |

## Local and secret configuration

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

## Validate

```sh
./scripts/check.sh
```

The checker always performs Bash and Zsh syntax checks. It also runs ShellCheck
and WezTerm validation when those programs are installed.
