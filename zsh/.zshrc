# Powerlevel10k instant prompt must stay near the top of this file.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Keep PATH ordered and free of duplicate entries.
typeset -U path PATH
dotfiles_bin_dirs=(
  "$HOME/.local/bin"
  "$HOME/.opencode/bin"
  "$HOME/.pub-cache/bin"
  "$HOME/.gem/bin"
  "$HOME/.dotnet/tools"
  "$HOME/development/flutter/bin"
  "${GOPATH:-$HOME/go}/bin"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  /usr/local/share/dotnet
)
for dotfiles_bin_dir in ${(Oa)dotfiles_bin_dirs}
do
  [[ -d "$dotfiles_bin_dir" ]] && path=("$dotfiles_bin_dir" $path)
done
unset dotfiles_bin_dir dotfiles_bin_dirs

if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
elif [[ -d /usr/local/Homebrew ]]; then
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/usr/local}"
fi

export EDITOR=nvim
export VISUAL="$EDITOR"
export PAGER=less
export LESS='-FRXR'
export LANG=en_US.UTF-8

# History shared across interactive shells.
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
if [[ -r "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  ZSH_THEME='powerlevel10k/powerlevel10k'
else
  ZSH_THEME=''
fi
zstyle ':omz:update' mode reminder
DISABLE_CORRECTION=true

dotfiles_desired_plugins=(
  git
  docker
  docker-compose
  macos
  dotenv
  web-search
  git-flow-completion
  s3cmd
  virtualenv
  flutter
  zsh-autosuggestions
  zsh-syntax-highlighting
)

plugins=()
for dotfiles_plugin in $dotfiles_desired_plugins; do
  if [[ -d "$ZSH/plugins/$dotfiles_plugin" ||
        -d "$ZSH_CUSTOM/plugins/$dotfiles_plugin" ]]; then
    plugins+=("$dotfiles_plugin")
  fi
done
unset dotfiles_desired_plugins dotfiles_plugin

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if (( ${plugins[(Ie)zsh-autosuggestions]} == 0 )) &&
   [[ -r "${HOMEBREW_PREFIX:-}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

[[ -r "$HOME/.aliases" ]] && source "$HOME/.aliases"

typeset -gA _fzcmd_descriptions
[[ -r "$HOME/.fzcmd_descriptions.zsh" ]] &&
  source "$HOME/.fzcmd_descriptions.zsh"

# fzf defaults
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height=50% --layout=reverse --border --preview "if [[ -f {} ]]; then (bat --style=numbers --color=always -- {} 2>/dev/null || cat -- {}); elif [[ -d {} ]]; then tree -C -- {} 2>/dev/null | head -200; fi"'

[[ -r "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

_dotfiles_require() {
  local command_name
  for command_name in "$@"; do
    if (( ! $+commands[$command_name] )); then
      print -u2 -- "Missing command: $command_name"
      return 127
    fi
  done
}

# Render Markdown with terminal-aware styling and readable wrapping. Oh My Zsh
# already defines `md` as an alias for `mkdir -p`, so use a distinct name.
mdview() {
  _dotfiles_require glow || return
  command glow --pager --width "${COLUMNS:-100}" -- "$@"
}

fzne() {
  _dotfiles_require fd fzf nvim || return
  local file
  file="$(fd --type f --hidden --follow --exclude .git . |
    fzf --query "${1:-}" --select-1 --exit-0 --preview 'bat --style=numbers --color=always -- {} 2>/dev/null || cat -- {}')" || return
  [[ -n "$file" ]] && command nvim -- "$file"
}

fznea() {
  _dotfiles_require fd fzf nvim || return
  local file
  file="$(fd --type f --hidden --follow --no-ignore . |
    fzf --query "${1:-}" --select-1 --exit-0 --preview 'bat --style=numbers --color=always -- {} 2>/dev/null || cat -- {}')" || return
  [[ -n "$file" ]] && command nvim -- "$file"
}

fzcd() {
  _dotfiles_require fd fzf || return
  local directory
  directory="$(fd --type d --hidden --follow --exclude .git . |
    fzf --query "${1:-}" --select-1 --exit-0 --preview 'tree -C -- {} 2>/dev/null | head -200')" || return
  [[ -n "$directory" ]] && builtin cd -- "$directory"
}

ffcd() {
  _dotfiles_require fd fzf || return
  local file
  file="$(fd --type f --hidden --follow --exclude .git . |
    fzf --query "${1:-}" --select-1 --exit-0 --preview 'bat --style=numbers --color=always -- {} 2>/dev/null || cat -- {}')" || return
  [[ -n "$file" ]] && builtin cd -- "${file:h}"
}

fzrg() {
  _dotfiles_require rg fzf nvim || return
  local query="${1:-}" result file rest line
  [[ -n "$query" ]] || { print -u2 'Usage: fzrg <pattern>'; return 2; }

  result="$(rg --color=never --line-number --no-heading --smart-case -- "$query" |
    fzf --delimiter=: --preview 'bat --style=numbers --color=always --highlight-line {2} -- {1}' --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' --bind 'change:reload:rg --color=never --line-number --no-heading --smart-case -- {q} || true' --query "$query")" || return

  file="${result%%:*}"
  rest="${result#*:}"
  line="${rest%%:*}"
  [[ -n "$file" && -n "$line" ]] && command nvim "+$line" -- "$file"
}

fzgit() {
  _dotfiles_require git fzf nvim || return
  git rev-parse --is-inside-work-tree &>/dev/null || {
    print -u2 'Not inside a Git repository.'
    return 1
  }

  local file
  file="$(git ls-files |
    fzf --query "${1:-}" --select-1 --exit-0 --preview 'bat --style=numbers --color=always -- {} 2>/dev/null || cat -- {}')" || return
  [[ -n "$file" ]] && command nvim -- "$file"
}

fzconf() {
  _dotfiles_require fd fzf nvim || return
  [[ -d "$HOME/.config" ]] || { print -u2 '~/.config does not exist.'; return 1; }

  local file
  file="$(fd --type f . "$HOME/.config" |
    fzf --preview 'bat --style=numbers --color=always -- {} 2>/dev/null || cat -- {}')" || return
  [[ -n "$file" ]] && command nvim -- "$file"
}

fzh() {
  _dotfiles_require fzf || return
  local selected_command
  selected_command="$(fc -rl 1 | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' |
    awk '!seen[$0]++' | fzf --query "${1:-}")" || return
  [[ -n "$selected_command" ]] && print -z -- "$selected_command"
}

fzcmd() {
  _dotfiles_require fzf || return
  local selected_line command_name definition description command_type command_path

  selected_line="$(
    {
      for command_name definition in ${(kv)aliases}; do
        description="${_fzcmd_descriptions[$command_name]:--}"
        printf 'alias\t%s\t%s\t%s\n' "$command_name" "$definition" "$description"
      done
      for command_name in ${(ok)functions}; do
        [[ "$command_name" == _* ]] && continue
        description="${_fzcmd_descriptions[$command_name]:--}"
        printf 'function\t%s\t-\t%s\n' "$command_name" "$description"
      done
      for command_name in ${(k)builtins}; do
        description="${_fzcmd_descriptions[$command_name]:--}"
        printf 'builtin\t%s\t-\t%s\n' "$command_name" "$description"
      done
      for command_name command_path in ${(kv)commands}; do
        description="${_fzcmd_descriptions[$command_name]:--}"
        printf 'executable\t%s\t%s\t%s\n' "$command_name" "$command_path" "$description"
      done
    } | fzf --query="${1:-}" --delimiter=$'\t' --with-nth=2,4 --header='ENTER: insert command  ·  TAB: toggle preview' --bind='tab:toggle-preview' --preview='printf "Type: %s\nCommand: %s\nDescription: %s\nSource: %s\n" {1} {2} {4} {3}' --preview-window='right,55%,border-left' --select-1 --exit-0
  )" || return

  command_name="${${(s:\t:)selected_line}[2]}"
  [[ -n "$command_name" ]] && print -z -- "$command_name"
}

# Cache the generated alias so Python does not run for every new shell.
if (( $+commands[thefuck] )); then
  dotfiles_thefuck_cache="${XDG_CACHE_HOME:-$HOME/.cache}/thefuck/alias.zsh"
  if [[ ! -r "$dotfiles_thefuck_cache" ||
        "$commands[thefuck]" -nt "$dotfiles_thefuck_cache" ]]; then
    command mkdir -p -- "${dotfiles_thefuck_cache:h}" 2>/dev/null &&
      command thefuck --alias >| "$dotfiles_thefuck_cache" 2>/dev/null
  fi
  [[ -r "$dotfiles_thefuck_cache" ]] && source "$dotfiles_thefuck_cache"
  unset dotfiles_thefuck_cache
fi

if [[ -n "${HOMEBREW_PREFIX:-}" &&
      -r "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh" ]]; then
  source "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"
fi

# Lazy-load NVM the first time a Node-related command is used.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  _load_nvm() {
    unfunction nvm node npm npx 2>/dev/null
    source "$NVM_DIR/nvm.sh"
  }
  nvm()  { _load_nvm && nvm "$@"; }
  node() { _load_nvm && node "$@"; }
  npm()  { _load_nvm && npm "$@"; }
  npx()  { _load_nvm && npx "$@"; }
fi

[[ -r "$HOME/.iterm2_shell_integration.zsh" ]] &&
  source "$HOME/.iterm2_shell_integration.zsh"
[[ -r "$HOME/.dart-cli-completion/zsh-config.zsh" ]] &&
  source "$HOME/.dart-cli-completion/zsh-config.zsh"

if [[ -x /usr/libexec/java_home ]]; then
  dotfiles_java_home="$(/usr/libexec/java_home -v 17 2>/dev/null)" &&
    export JAVA_HOME="$dotfiles_java_home"
  unset dotfiles_java_home
fi

voluntinder-mock() {
  local project_root="${VOST_ROOT:-$HOME/git/vost}"
  local launcher="$project_root/DARE_DASHBOARD/scripts/voluntinder-local"
  local secret

  [[ -x "$launcher" ]] || {
    print -u2 -- "Missing executable: $launcher"
    return 1
  }
  secret="$(security find-generic-password -a "$USER" -s dare-voluntinder-local-secret -w)" || return
  DARE_CLIENT_SECRET="$secret" "$launcher" start
}

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Machine-specific or secret configuration belongs here and stays untracked.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Syntax highlighting must be the final plugin sourced.
if (( ${plugins[(Ie)zsh-syntax-highlighting]} == 0 )) &&
   [[ -r "${HOMEBREW_PREFIX:-}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
