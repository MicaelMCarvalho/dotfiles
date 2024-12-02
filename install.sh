#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES=$PWD

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}
log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to create a symlink
create_symlink() {
    local src="$1"
    local dest="$2"
    
    # Check if the source file exists
    if [ ! -f "$src" ]; then
        log_error "Source file $src does not exist"
        return 1
    fi
    
    # Remove existing file or symlink
    if [ -f "$dest" ] || [ -L "$dest" ]; then
        log_warning "Removing existing file: $dest"
        rm "$dest"
    fi
    
    # Create the symlink
    ln -s "$src" "$dest"
    if [ $? -eq 0 ]; then
        log_info "Created symlink: $dest -> $src"
    else
        log_error "Failed to create symlink for $dest"
    fi
}

# Main installation
main() {
    log_info "Starting dotfiles installation..."
    
    # Create required directories
    # create_directories
     
    # Git configurations
    create_symlink "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$DOTFILES/git/.gitconfig-work" "$HOME/.gitconfig-work"
    create_symlink "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"
    
    # Wezterm configuration
    create_symlink "$DOTFILES/wezterm/.wezterm.lua" "$HOME/wezterm.lua"
    
    # ZSH configurations
    create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES/zsh/.aliases" "$HOME/.aliases"
    
    log_info "Installation completed!"
}

# Run the installatio:
main
