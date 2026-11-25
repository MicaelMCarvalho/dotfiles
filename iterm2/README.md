# iTerm2 configuration

The [`WezTerm-like` dynamic profile](wezterm-like.json) shares colors, pane
navigation, and tab shortcuts with the [WezTerm config](../wezterm/.wezterm.lua).

## Install and verify

Follow the [main setup instructions](../README.md#install), then quit and
reopen iTerm2. The installer links the dynamic profile, selects it as the
default for new sessions, and sets `Ctrl-a` as iTerm2's global leader. It also
hides scrollbars and dims inactive panes.

If a new window opens with another profile, look for `WezTerm-like` in
**Settings → Profiles** and check that the link points to your checkout:

```sh
readlink "$HOME/Library/Application Support/iTerm2/DynamicProfiles/wezterm-like.json"
```

If the profile is missing, rerun `./install.sh` from the checkout and restart
iTerm2. Zsh loads the integration bundled with iTerm2 when you open a local
iTerm2 session, with an existing `~/.iterm2_shell_integration.zsh` taking
precedence.

## Key mappings

For a leader shortcut, press `Ctrl-a`, release it, then press the second key.

| Key | Action |
| --- | --- |
| `Option-Left` / `Option-Right` | Move backward / forward one word |
| `Command-Left` / `Command-Right` | Move to the start / end of the line |
| `Option-Backspace` | Delete the previous word |
| `Command-Backspace` | Delete to the start of the line |
| `Control-Shift-Arrow` | Focus the pane in the arrow's direction |
| `Ctrl-a s` / `Ctrl-a v` | Split top/bottom / left/right |
| `Ctrl-a h/j/k/l` | Focus the pane left/down/up/right |
| `Ctrl-a q` | Close the current pane with confirmation |
| `Ctrl-a z` | Maximize or restore the active pane |
| `Ctrl-a t` | Open a tab using the current working directory |
| `Ctrl-a [` / `Ctrl-a ]` | Select the previous / next tab |
| `Ctrl-a ,` / `Ctrl-a .` | Move the current tab left / right |
| `Ctrl-a Shift-h/j/k/l` | Resize the pane left/down/up/right |
| `Ctrl-a b` | Toggle between opaque and 95% opacity |
| `Ctrl-a n`, `Ctrl-a w`, or `Ctrl-a ?` | Open iTerm2's Open Quickly palette |

Pane resizing and tab movement each use a direct leader shortcut. Use
`Command-1` through `Command-9` to select a tab by number. Open Quickly is
available from the same leader keys used for the WezTerm tab navigator,
workspace switcher, and fuzzy keybinding menu.
