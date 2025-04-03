# ~/.fzcmd_descriptions.zsh

# Associative array to hold custom command descriptions for fzcmd
# Loaded by ~/.zshrc

typeset -gA _fzcmd_descriptions
_fzcmd_descriptions=(
  # --- Aliases (Combined from original list and ~/.aliases content) ---
  # Shell Navigation
  ".."      "Go up one directory (cd ..)"
  "..."     "Go up two directories (cd ../..)"
  "...."    "Go up three directories (cd ../../..)"
  "....."   "Go up four directories (cd ../../../..)"
  "~"       "Go to home directory (cd ~)"
  "-"       "Go to previous directory (cd -)" # Note: Key is just "-"

  # Listing Commands
  "l"       "List files (long format, color)"
  "ls"      "List files (color, macOS)" # Overrides exec ls for description
  "ll"      "List files (long, human, color, macOS)"
  "la"      "List all files (long, human, color, macOS)"
  "ld"      "List directories only (long format, color, macOS)"

  # Development Shortcuts
  "py"      "Run python3"
  "pip"     "Run pip3"
  "python"  "Run python3"
  "act"     "Activate Python virtualenv (source venv/bin/activate)"
  "venv"    "Create Python virtualenv named 'venv'"
  "npmls"   "NPM: List top-level installed packages"
  "npmi"    "NPM: Install packages (npm install)"
  "npmu"    "NPM: Update packages"
  "dk"      "Run docker command"
  "dkc"     "Run docker-compose command"
  "dkps"    "Docker: List running containers (docker ps)"
  "dkst"    "Docker: Show container resource usage stats"

  # System Shortcuts (macOS)
  "flush-dns" "Flush macOS DNS cache"
  "ip"      "Show public IP info (uses ipinfo.io + jq)"
  "ports"   "Show listening network ports (lsof)"
  "sysprof" "Show system processes sorted by CPU (top)"

  # Personal Apps & Tools
  "rbt"     "Run Robot Framework tests (output to out_files/)"
  "gfl"     "Run git-flow command"
  "lz"      "Run lazygit (TUI Git client)"
  "fzn"     "FZF: Find file/dir & Edit (basic fzf + nvim)"
  "firefox" "Open Firefox application"
  "rm"      "Remove files interactively (safer rm -i)"
  "nv"      "Run nvim with isolated shada file"
  "awsdo"   "Run AWS CLI targeting DigitalOcean Spaces (AMS3, no SSL verify)"
  "nt"      "Open new iTerm window"
  "wez"     "Start WezTerm terminal application"

  # Flutter
  "fpg"     "Flutter: pub get"
  "frb"     "Flutter: run build_runner build --delete-conflicting-outputs"

  # --- Functions (Defined in ~/.zshrc) ---
  "fzne"    "FZF: Find file & Edit (nvim, respects .git)"
  "fznea"   "FZF: Find file (All) & Edit (nvim)"
  "fzcd"    "FZF: Find directory & cd into it"
  "ffcd"    "FZF: Find file & cd to its directory"
  "fzrg"    "FZF: Ripgrep content & Edit (nvim)"
  "fzgit"   "FZF: Find Git tracked file & Edit (nvim)"
  "fzconf"  "FZF: Find config file (~/.config) & Edit (nvim)"
  "fzh"     "FZF: Search Zsh History & print command"
  "fzcmd"   "FZF: Find Command (this tool!)"
  # Add descriptions for any other custom functions you define here

  # --- Common Executables (Examples - Add more as needed) ---
  "git"     "Distributed version control system"
  "nvim"    "Hyperextensible Vim-based text editor"
  "docker"  "Containerization platform"
  "python3" "Python 3 interpreter"
  "rg"      "ripgrep: recursively search current directory for lines matching a pattern"
  "fd"      "fd: simple, fast and user-friendly alternative to find"
  "fzf"     "Command-line fuzzy finder"
  "man"     "Interface to the online reference manuals"
  "brew"    "The Missing Package Manager for macOS (or Linux)"
  "top"     "Display Linux/macOS processes"
  "lsof"    "List open files"
  "curl"    "Transfer data from or to a server"
  "jq"      "Command-line JSON processor"
  "bat"     "Cat(1) clone with wings (syntax highlighting, git)"
  "tree"    "List contents of directories in a tree-like format"
  "aws"     "AWS Command Line Interface"
  "npm"     "Node Package Manager"
  "node"    "Node.js JavaScript runtime"
  "flutter" "Flutter SDK command line tool"
  "dart"    "Dart SDK command line tool"
  # Add your own important commands here!
  # "my_script" "Does that awesome thing I wrote"
)
