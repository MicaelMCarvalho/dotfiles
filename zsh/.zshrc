# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Update behavior
zstyle ':omz:update' mode reminder

# Disable command auto-correction
ENABLE_CORRECTION="false"

# Plugins
plugins=(
  git
  docker
  docker-compose
  macos
  dotenv
  web-search
  zsh-autosuggestions
  git-flow-completion
  s3cmd
  virtualenv
  flutter
)

source $ZSH/oh-my-zsh.sh


# thefuck configuration
eval $(thefuck --alias)

# Autojump
[ -f $HOMEBREW_PREFIX/etc/profile.d/autojump.sh ] && . $HOMEBREW_PREFIX/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# FZF functions and configuration
fzd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf -i +m) &&
  cd "$dir"
}

fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "$PWD") | fzf +m)
  cd "$DIR"
}

source "${HOME}/.aliases"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'

# Powerlevel9k configuration
export POWERLEVEL9K_INSTANT_PROMPT=quiet
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv)

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Path configuration
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$PATH:/Users/micael/.dotnet/tools"
export PATH="/usr/local/share/dotnet:$PATH"
export PATH=/usr/local/bin/:$PATH
export PATH=$HOME/development/flutter/bin:$PATH
export PATH=$HOME/.gem/bin:$PATH

# iTerm2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Language configuration
export LC_ALL=en_US.UTF-8

