#!/usr/bin/env bash

set -Eeuo pipefail

readonly DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup}"
readonly BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"

DRY_RUN=false
backup_created=false

info() { printf '\033[0;32m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[0;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Creates symlinks in your home directory. Existing files are moved to a
timestamped directory under ~/.dotfiles-backup before being replaced.
EOF
}

run() {
  if "$DRY_RUN"; then
    printf '[DRY RUN]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

backup_existing() {
  local destination="$1"
  local relative_path="${destination#"$HOME"/}"
  local backup_path="$BACKUP_DIR/$relative_path"

  if ! "$backup_created"; then
    run mkdir -p -- "$BACKUP_DIR"
    backup_created=true
  fi

  run mkdir -p -- "$(dirname -- "$backup_path")"
  run mv -- "$destination" "$backup_path"
  warn "Backed up $destination to $backup_path"
}

link_path() {
  local source="$1"
  local destination="$2"

  [[ -e "$source" ]] || die "Missing source path: $source"

  if [[ -L "$destination" && "$(readlink -- "$destination")" == "$source" ]]; then
    info "Already linked: $destination"
    return
  fi

  if [[ -e "$destination" || -L "$destination" ]]; then
    backup_existing "$destination"
  fi

  run mkdir -p -- "$(dirname -- "$destination")"
  run ln -s -- "$source" "$destination"
  info "Linked $destination -> $source"
}

main() {
  case "${1:-}" in
    "") ;;
    --dry-run) DRY_RUN=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "Unknown option: $1" ;;
  esac

  info "Installing dotfiles from $DOTFILES_DIR"

  link_path "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  link_path "$DOTFILES_DIR/git/.gitconfig-work" "$HOME/.gitconfig-work"
  link_path "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
  link_path "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
  link_path "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  link_path "$DOTFILES_DIR/zsh/.aliases" "$HOME/.aliases"
  link_path "$DOTFILES_DIR/zsh/.fzcmd_descriptions.zsh" "$HOME/.fzcmd_descriptions.zsh"
  link_path "$DOTFILES_DIR/karabiner" "$HOME/.config/karabiner"

  info "Installation complete. Open a new shell to load the changes."
  "$backup_created" && info "Backups are in $BACKUP_DIR"
}

main "$@"
