#!/bin/bash

set -e

# Check if dialog is installed, install if not
if ! command -v dialog &> /dev/null; then
    echo "Installing dialog for TUI interface..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install dialog
    elif [[ -f /etc/debian_version ]]; then
        sudo apt-get update && sudo apt-get install -y dialog
    elif [[ -f /etc/redhat-release ]]; then
        sudo yum install -y dialog
    fi
fi

create_symlink() {
    local source=$1
    local target=$2
    local target_dir=$(dirname "$target")

    mkdir -p "$target_dir"

    if [ -L "$target" ] || [ -f "$target" ]; then
        echo "Removing existing $target"
        rm -rf "$target"
    fi

    echo "Creating symlink: $target -> $source"
    ln -s "$(pwd)/$source" "$target"
}

install_brew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew is already installed"
    fi
}

install_nvm() {
    if ! command -v nvm &> /dev/null; then
        echo "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        echo "Installing latest Node.js version..."
        nvm install node
    else
        echo "nvm is already installed"
    fi
}

install_cargo() {
    if ! command -v cargo &> /dev/null; then
        echo "Installing Rust and Cargo..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        echo "Cargo is already installed"
    fi
}

# Create TUI menu
show_menu() {
    dialog --title "Dotfiles Setup" \
           --checklist "Select tools to install:" 15 60 5 \
           1 "Brew (Package Manager)" on \
           2 "NVM (Node Version Manager)" on \
           3 "Cargo (Rust Package Manager)" on \
           2>&1 > /dev/tty
}

# Main installation function
install_selected() {
    local choices=($(show_menu))
    
    for choice in "${choices[@]}"; do
        case $choice in
            1) install_brew ;;
            2) install_nvm ;;
            3) install_cargo ;;
        esac
    done
}

# Create default .zshrc if it doesn't exist
if [ ! -f "$(pwd)/.zshrc" ]; then
    echo "Creating default .zshrc file"
    cat > "$(pwd)/.zshrc" << 'EOF'
# Zsh configuration
# Add your zsh configuration here
EOF
fi

# Show installation menu
install_selected

# Create symlinks
create_symlink "nvim" "$HOME/.config/nvim"
create_symlink "btop" "$HOME/.config/btop"
create_symlink "gh" "$HOME/.config/gh"
create_symlink "tmux" "$HOME/.config/tmux"
create_symlink ".zshrc" "$HOME/.zshrc"

echo "Setup complete! Your dotfiles have been linked." 