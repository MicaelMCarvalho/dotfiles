# ~/.zshrc

# Powerlevel10k instant prompt
# To speed up shell startup, this sources the Powerlevel10k instant prompt cache.
# IMPORTANT: This should be the first lines in ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Update behavior
zstyle ':omz:update' mode reminder

# Disable command auto-correction (personal preference)
ENABLE_CORRECTION="false"

# Plugins - Ensure zsh-autosuggestions and zsh-syntax-highlighting are last or near last
plugins=(
  git
  docker
  docker-compose
  macos
  dotenv
  web-search
  git-flow-completion # Ensure git-flow is installed
  s3cmd # Ensure s3cmd is installed
  virtualenv
  flutter
  # Add fzf plugin if desired (provides some extra completions, but core bindings come from install script)
  # fzf
  zsh-autosuggestions # Must be loaded after other plugins potentially providing widgets
  zsh-syntax-highlighting # Must be loaded last
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
# Note: User configuration (like PATH, aliases, functions) should generally come AFTER sourcing oh-my-zsh.sh

# -----------------------------------------------------------------------------
# Aliases, Functions, and Custom Configuration
# -----------------------------------------------------------------------------

# Load personal aliases (Ensure this file exists)
if [[ -f "${HOME}/.aliases" ]]; then
  source "${HOME}/.aliases"
else
  echo "Warning: Alias file ~/.aliases not found." >&2
fi

# --- Load FZF Command Descriptions ---
if [[ -f "${HOME}/.fzcmd_descriptions.zsh" ]]; then
  source "${HOME}/.fzcmd_descriptions.zsh"
else
   # Optional: Define an empty array if file missing, so fzcmd doesn't error
   typeset -gA _fzcmd_descriptions
   echo "Warning: FZF description file ~/.fzcmd_descriptions.zsh not found." >&2
fi

# --- FZF (Fuzzy Finder) Configuration & Functions ---
# Dependencies: brew install fzf fd ripgrep bat tree
# IMPORTANT: Run fzf install script: $(brew --prefix)/opt/fzf/install
#            (Enables CTRL-T, CTRL-R, ALT-C keybindings and fuzzy completion)

# Use fd (faster find) for default file searching (CTRL-T)
# Respects .gitignore, includes hidden files, follows symlinks
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Use fd for directory searching (ALT-C)
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Add a preview window (requires bat and tree for optimal display)
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --preview "([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | head -200)) || echo {} 2> /dev/null | head -200"'

# Find file with fd and open in Neovim (like Telescope find_files)
# Usage: fzne [initial_query]
fzne() {
  local file
  file=$(fd --type f --hidden --follow --exclude .git . | fzf --query "$1" --select-1 --exit-0 --preview "bat --style=numbers --color=always {} || cat {}")
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# Find file with fd (including gitignored) and open in Neovim
# Usage: fznea [initial_query]
fznea() {
    local file
    file=$(fd --type f --hidden --follow --no-ignore . | fzf --query "$1" --select-1 --exit-0 --preview "bat --style=numbers --color=always {} || cat {}")
    if [[ -n "$file" ]]; then
        nvim "$file"
    fi
}

# Find directory with fd and cd into it (like ALT-C but as a command)
# Usage: fzcd [initial_query]
fzcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git . | fzf --query "$1" --select-1 --exit-0 --preview 'tree -C {} | head -200')
  if [[ -n "$dir" ]]; then
    cd "$dir" || return 1 # cd and handle potential errors
  fi
}

# Find a file using fd/fzf and cd into its containing directory
# Usage: ffcd [initial_query]
ffcd() {
  local selected_file_path
  # Use fd to find files, pipe to fzf for selection
  # Preview the file content during selection
  selected_file_path=$(fd --type f --hidden --follow --exclude .git . | fzf --query "$1" --select-1 --exit-0 --preview "bat --style=numbers --color=always {} || cat {}")

  # Check if the user actually selected a file (fzf exited successfully)
  if [[ -n "$selected_file_path" ]]; then
    # Get the directory name from the selected file path
    local target_directory
    target_directory=$(dirname "$selected_file_path")

    # Check if dirname successfully extracted a directory path
    if [[ -n "$target_directory" ]]; then
      echo "Changing to directory: $target_directory" # Optional: Confirmation message
      # Change to the target directory
      cd "$target_directory" || return 1 # Use || return 1 to handle potential cd errors
    else
        echo "Error: Could not determine directory for '$selected_file_path'." >&2
        return 1
    fi
  fi
  # If nothing selected or dirname failed, do nothing further (implicitly returns 0 or the error code from cd/dirname)
}

# Find file by content using ripgrep (rg) and open in Neovim (like Telescope live_grep)
# Usage: fzrg <pattern>
fzrg() {
  if [[ -z "$1" ]]; then
    echo "Usage: fzrg <pattern>"
    return 1
  fi
  local result
  # Search with rg, pipe to fzf with live reload and preview
  result=$(rg --color=always --line-number --no-heading --smart-case "$1" | fzf \
    --ansi \
    --delimiter ':' \
    --preview "bat --style=numbers --color=always --highlight-line {2} {1}" \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'change:reload:rg --color=always --line-number --no-heading --smart-case {q} || true' \
    --query "$1")

  if [[ -n "$result" ]]; then
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    nvim "+$line" "$file"
  fi
}

# Find Git files and open in Neovim (like Telescope git_files)
# Usage: fzgit [initial_query]
fzgit() {
    local file
    # Use git ls-files to list tracked files
    file=$(git ls-files | fzf --query "$1" --select-1 --exit-0 --preview "bat --style=numbers --color=always {} || cat {}")
    if [[ -n "$file" ]]; then
        nvim "$file"
    fi
}

# Find config files under ~/.config and edit with Neovim
# Usage: fzconf
fzconf() {
  local file
  # Search specifically in ~/.config using fd
  file=$(fd --type f . "$HOME/.config" | fzf --preview "bat --style=numbers --color=always {} || cat {}")
  if [[ -n $file ]]; then
    nvim "$file"
  fi
}

# Find Zsh history and execute command (like CTRL-R but puts command on prompt)
# Usage: fzh [initial_query]
fzh() {
  local cmd
  # fc -lrn 1: list history reverse numerically without line numbers starting from 1
  # awk '!x[$0]++': remove duplicates keeping the most recent
  cmd=$(fc -lrn 1 | awk '!x[$0]++' | fzf --query "$1")
  if [[ -n "$cmd" ]]; then
    # print -z: push command onto the editing buffer stack (zle)
    print -z -- "$cmd"
  fi
}

# Fuzzy find available commands (aliases, functions, builtins, executables) with descriptions
# Usage: fzcmd [initial_query]
fzcmd() {
  # Declare variables locally
  local selected_line cmd

  # Generate the list and pipe it directly to fzf
  # No 'line=$(...)' command substitution here
  selected_line=$( # Capture the output of fzf using command substitution
    {
      # 1. Aliases... (unchanged)
      for cmd def in ${(kv)aliases}; do
        desc=${_fzcmd_descriptions[$cmd]:-"-"}
        printf "alias\t%s\t'%s'\t%s\n" "$cmd" "$def" "$desc"
      done
      # 2. Functions... (unchanged)
      for cmd in ${(ok)functions}; do
        [[ "$cmd" == _* ]] && continue
        desc=${_fzcmd_descriptions[$cmd]:-"-"}
        printf "func\t%s\t-\t%s\n" "$cmd" "$desc"
      done
      # 3. Builtins... (unchanged)
      for cmd in ${(k)builtins}; do
        desc=${_fzcmd_descriptions[$cmd]:-"-"}
        printf "builtin\t%s\t-\t%s\n" "$cmd" "$desc"
      done
      # 4. Executables... (unchanged)
      for cmd in ${(k)commands}; do
          local cmd_type=$(type -w "$cmd" 2>/dev/null | cut -d' ' -f3)
          if [[ "$cmd_type" == "file" || "$cmd_type" == "hashed" ]]; then
              local cmd_path=${commands[$cmd]}
              desc=${_fzcmd_descriptions[$cmd]:-"-"}
              printf "exec\t%s\t%s\t%s\n" "$cmd" "${cmd_path:--}" "$desc"
          fi
      done
    } | fzf --query="$1" --delimiter='\t' \
          --with-nth=2,4 \
          --preview-window='right,60%,border-left' \
          --color='header:italic' \
          --header='[ TAB: Toggle Preview | ENTER: Insert Command | CTRL-C: Abort ]' \
          --preview '
            # Preview script unchanged...
            IFS=$'\''\t'\'' read -r type cmd def_or_path desc <<< "${}";
            printf "Type:    \033[1m%s\033[0m\n" "$type";
            printf "Command: \033[1;36m%s\033[0m\n" "$cmd";
            [[ "$desc" != "-" ]] && printf "Desc:    %s\n" "$desc";
            echo "------------------------------";
            if [[ "$type" == "alias" ]]; then
              def_unquoted=$(echo "$def_or_path" | sed "s/^'\''\(.*\)'\''$/\1/")
              printf "Definition: %s\n" "$def_unquoted";
            elif [[ "$type" == "func" ]]; then
              echo "Definition (Source):";
              (command -v bat >/dev/null && bat --style=plain --color=always --language=sh <(functions "$cmd")) || type "$cmd" 2>/dev/null || echo "(Could not display source)";
            elif [[ "$type" == "builtin" ]]; then
              echo "(Shell Builtin)"; echo ""; echo "Description (whatis):"; whatis "$cmd" 2>/dev/null || echo "(No whatis entry)";
            elif [[ "$type" == "exec" ]];
              printf "Path: %s\n" "${def_or_path:-(Not found)}"; echo ""; echo "Description (whatis):"; whatis "$cmd" 2>/dev/null || { [[ "$desc" == "-" ]] && echo "(No custom desc or whatis entry - try: man ${cmd})"; } || true
            fi
          ' \
          --bind 'tab:toggle-preview' \
          --bind 'enter:accept' \
          --select-1 \
          --exit-0
  ) # End of command substitution capturing fzf output

  # Check if fzf returned a selection (selected_line is not empty)
  if [[ -n "$selected_line" ]]; then
    # Extract the command name (second field) from the selected line
    # Use awk for reliable field splitting on tab
    cmd=$(echo "$selected_line" | awk -F'\t' '{print $2}')

    # Check if command extraction was successful
    if [[ -n "$cmd" ]]; then
        # Use print -z to push the command onto the ZLE buffer
        print -z -- "$cmd"
        # Optional: Force redraw if input doesn't appear immediately
        # zle && zle redisplay
    fi
  fi
  # If the user pressed Esc or fzf failed, selected_line will be empty,
  # and nothing will be pushed to the prompt.
}

# --- End FZF Section ---


# thefuck configuration (Auto-corrects previous command mistakes)
# Ensure thefuck is installed: brew install thefuck
eval $(thefuck --alias)

# Autojump (Navigate directories faster based on usage)
# Ensure autojump is installed: brew install autojump
if [ -f "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh" ]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"
  # Zsh completion for autojump needs compinit initialized
  # autoload -U compinit && compinit -u # This might be redundant if OMZ already does it
else
  echo "Warning: autojump script not found." >&2
fi
# Note: Oh My Zsh usually runs compinit, so the autoload line might be unnecessary unless you have issues.

# NVM configuration (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
   \. "$NVM_DIR/nvm.sh" # This loads nvm
   # Loading bash_completion for nvm can sometimes cause delays or conflicts in zsh.
   # Only uncomment the next line if you specifically need nvm's bash completion features in zsh and know it works well.
   # [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
  echo "Warning: NVM script not found in $NVM_DIR" >&2
fi

# PATH configuration (Order matters: earlier entries take precedence)
# Consolidate PATH modifications for clarity. Add new paths *before* $PATH.

# Add Go bin directory
[[ -d "$(go env GOPATH)/bin" ]] && export PATH="$(go env GOPATH)/bin:$PATH"

# Add .NET tools directory
[[ -d "$HOME/.dotnet/tools" ]] && export PATH="$HOME/.dotnet/tools:$PATH"
[[ -d "/usr/local/share/dotnet" ]] && export PATH="/usr/local/share/dotnet:$PATH" # Standard dotnet location

# Add Homebrew bin (often handled by brew setup, but doesn't hurt to ensure)
[[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"
[[ -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH" # For Apple Silicon

# Add Flutter SDK bin directory
[[ -d "$HOME/development/flutter/bin" ]] && export PATH="$HOME/development/flutter/bin:$PATH"

# Add Ruby gems bin directory
[[ -d "$HOME/.gem/bin" ]] && export PATH="$HOME/.gem/bin:$PATH"

# Add Flutter/Dart pub cache bin directory
[[ -d "$HOME/.pub-cache/bin" ]] && export PATH="$HOME/.pub-cache/bin:$PATH"

# Ensure PATH only contains unique entries (optional, requires awk)
# export PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '!arr[$0]++{print $0}' | sed 's/:$//')

# iTerm2 integration (Provides features like marks, cwd reporting, etc.)
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Language configuration (Set locale for consistent program behavior)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8 # Often good to set LANG as well

# Dart CLI completion
if [[ -f /Users/micael/.dart-cli-completion/zsh-config.zsh ]]; then
  . /Users/micael/.dart-cli-completion/zsh-config.zsh
else
  # Optional: echo warning if you expect it to be there
  # echo "Warning: Dart CLI completion script not found." >&2
  true # Ensure the script doesn't fail if the file is missing
fi

# Commented out old Powerlevel9k config - likely superseded by P10k
# export POWERLEVEL9K_INSTANT_PROMPT=quiet
# export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv)


# --- End of ~/.zshrc ---

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Load Powerlevel10k configuration
# IMPORTANT: This should be the last thing sourced in ~/.zshrc
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
