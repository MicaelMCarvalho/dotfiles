# iTerm2 configuration

`wezterm-like.json` is an iTerm2 dynamic profile that mirrors the repository's
WezTerm setup. The main installer links it into iTerm2's `DynamicProfiles`
directory, selects it as the default profile, and configures `Ctrl-a` as the
global leader key.

## Key mappings

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

iTerm2 has one two-stroke leader rather than WezTerm's nested key tables, so
resize and tab movement use direct leader chords. Use native `Command-1` through
`Command-9` to select a tab by number. Open Quickly is the closest native match
for WezTerm's tab navigator, workspace switcher, and fuzzy keybinding menu.

Restart iTerm2 after running the installer so its global preferences reload.
Inactive panes use gentle pane-wide dimming so they remain distinct and readable.
Scrollbars are hidden to match the cleaner WezTerm pane layout.
