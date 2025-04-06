#!/bin/bash

set -e

create_symlink() {
    local source=$1
    local target=$2
    local target_dir=$(dirname "$target")

    # Create directory and symlink silently
    mkdir -p "$target_dir" >/dev/null 2>&1
    if [ -L "$target" ] || [ -f "$target" ]; then
        rm -rf "$target" >/dev/null 2>&1
    fi
    ln -s "$(pwd)/$source" "$target" >/dev/null 2>&1
}

# Show progress in dialog
show_progress() {
    local title=$1
    local message=$2
    local percent=$3
    echo "$percent" | dialog --title "$title" --gauge "$message" 10 70 0
}

# Install Homebrew first if not present
if ! command -v brew &> /dev/null; then
    show_progress "Installing Homebrew" "Downloading and installing Homebrew..." 0
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1
    show_progress "Installing Homebrew" "Configuring Homebrew..." 50
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    show_progress "Installing Homebrew" "Homebrew installation complete!" 100
    sleep 1
else
    dialog --title "Homebrew" --infobox "Homebrew is already installed" 5 50
    sleep 1
fi

# Now install dialog using the appropriate package manager
if ! command -v dialog &> /dev/null; then
    show_progress "Installing dialog" "Installing dialog for TUI interface..." 0
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install dialog > /dev/null 2>&1
    elif [[ -f /etc/debian_version ]]; then
        sudo apt-get update > /dev/null 2>&1 && sudo apt-get install -y dialog > /dev/null 2>&1
    elif [[ -f /etc/redhat-release ]]; then
        sudo yum install -y dialog > /dev/null 2>&1
    fi
    show_progress "Installing dialog" "Dialog installation complete!" 100
    sleep 1
fi

install_nvm() {
    if ! command -v nvm &> /dev/null; then
        show_progress "Installing NVM" "Downloading NVM..." 0
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash > /dev/null 2>&1
        show_progress "Installing NVM" "Configuring NVM..." 50
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        show_progress "Installing NVM" "Installing latest Node.js..." 75
        nvm install node > /dev/null 2>&1
        show_progress "Installing NVM" "NVM installation complete!" 100
        sleep 1
    else
        dialog --title "NVM" --infobox "NVM is already installed" 5 50
        sleep 1
    fi
}

install_cargo() {
    if ! command -v cargo &> /dev/null; then
        show_progress "Installing Rust" "Downloading Rust installer..." 0
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1
        show_progress "Installing Rust" "Configuring Rust..." 50
        source "$HOME/.cargo/env"
        show_progress "Installing Rust" "Rust installation complete!" 100
        sleep 1
    else
        dialog --title "Rust" --infobox "Rust and Cargo are already installed" 5 50
        sleep 1
    fi
}

install_gh() {
    if ! command -v gh &> /dev/null; then
        show_progress "Installing GitHub CLI" "Installing GitHub CLI..." 0
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install gh > /dev/null 2>&1
        elif [[ -f /etc/debian_version ]]; then
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null 2>&1
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update > /dev/null 2>&1
            sudo apt install gh > /dev/null 2>&1
        elif [[ -f /etc/redhat-release ]]; then
            sudo dnf install 'dnf-command(config-manager)' > /dev/null 2>&1
            sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo > /dev/null 2>&1
            sudo dnf install gh > /dev/null 2>&1
        fi
        show_progress "Installing GitHub CLI" "GitHub CLI installation complete!" 100
        sleep 1
    else
        dialog --title "GitHub CLI" --infobox "GitHub CLI is already installed" 5 50
        sleep 1
    fi
}

install_btop() {
    if ! command -v btop &> /dev/null; then
        show_progress "Installing btop" "Installing btop..." 0
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install btop > /dev/null 2>&1
        elif [[ -f /etc/debian_version ]]; then
            sudo apt install btop > /dev/null 2>&1
        elif [[ -f /etc/redhat-release ]]; then
            sudo dnf install btop > /dev/null 2>&1
        fi
        show_progress "Installing btop" "btop installation complete!" 100
        sleep 1
    else
        dialog --title "btop" --infobox "btop is already installed" 5 50
        sleep 1
    fi
}

install_nvim() {
    if ! command -v nvim &> /dev/null; then
        show_progress "Installing Neovim" "Installing Neovim..." 0
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install neovim > /dev/null 2>&1
        elif [[ -f /etc/debian_version ]]; then
            sudo apt install neovim > /dev/null 2>&1
        elif [[ -f /etc/redhat-release ]]; then
            sudo dnf install neovim > /dev/null 2>&1
        fi
        show_progress "Installing Neovim" "Neovim installation complete!" 100
        sleep 1
    else
        dialog --title "Neovim" --infobox "Neovim is already installed" 5 50
        sleep 1
    fi
}

install_tmux() {
    if ! command -v tmux &> /dev/null; then
        show_progress "Installing tmux" "Installing tmux..." 0
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install tmux > /dev/null 2>&1
        elif [[ -f /etc/debian_version ]]; then
            sudo apt install tmux > /dev/null 2>&1
        elif [[ -f /etc/redhat-release ]]; then
            sudo dnf install tmux > /dev/null 2>&1
        fi
        show_progress "Installing tmux" "tmux installation complete!" 100
        sleep 1
    else
        dialog --title "tmux" --infobox "tmux is already installed" 5 50
        sleep 1
    fi
}

# Create dev tools menu
show_dev_menu() {
    dialog --title "@tysonlmao/.config" \
           --checklist "Select development tools to install:" 15 60 5 \
           1 "NVM (Node Version Manager)" on \
           2 "Cargo (Rust Package Manager)" on \
           2>&1 > /dev/tty
}

# Create utilities menu
show_utils_menu() {
    dialog --title "@tysonlmao/.config" \
           --checklist "Select utilities to install:" 15 60 5 \
           1 "GitHub CLI" on \
           2 "btop (System Monitor)" on \
           3 "Neovim" on \
           4 "tmux" on \
           2>&1 > /dev/tty
}

# Main installation function
install_selected() {
    # Install development tools
    local dev_choices=($(show_dev_menu))
    for choice in "${dev_choices[@]}"; do
        case $choice in
            1) install_nvm ;;
            2) install_cargo ;;
        esac
    done

    # Install utilities
    local utils_choices=($(show_utils_menu))
    for choice in "${utils_choices[@]}"; do
        case $choice in
            1) install_gh ;;
            2) install_btop ;;
            3) install_nvim ;;
            4) install_tmux ;;
        esac
    done
}

# Create default .zshrc if it doesn't exist
if [ ! -f "$(pwd)/.zshrc" ]; then
    dialog --title "Creating .zshrc" --infobox "Creating default .zshrc file..." 5 50
    cat > "$(pwd)/.zshrc" << 'EOF'
# Zsh configuration
# Add your zsh configuration here
EOF
    sleep 1
fi

# Show installation menus
install_selected

# Create symlinks with progress
{
    echo "0"
    echo "XXX"
    echo "Setting up Neovim configuration..."
    echo "XXX"
    create_symlink "nvim" "$HOME/.config/nvim"
    echo "25"
    echo "XXX"
    echo "Setting up btop configuration..."
    echo "XXX"
    create_symlink "btop" "$HOME/.config/btop"
    echo "50"
    echo "XXX"
    echo "Setting up GitHub CLI configuration..."
    echo "XXX"
    create_symlink "gh" "$HOME/.config/gh"
    echo "75"
    echo "XXX"
    echo "Setting up tmux configuration..."
    echo "XXX"
    create_symlink "tmux" "$HOME/.config/tmux"
    echo "90"
    echo "XXX"
    echo "Setting up zsh configuration..."
    echo "XXX"
    create_symlink ".zshrc" "$HOME/.zshrc"
    echo "100"
    echo "XXX"
    echo "Symlinks created successfully!"
    echo "XXX"
} | dialog --title "Creating Symlinks" --gauge "Initializing..." 10 70 0

# Create success message
success_message="
Dotfiles have been configured

📁 config:
  • nvim
  • btop
  • gh
  • tmux
  • .zshrc

next steps:
1. close thy terminal
3. get to work

you know what button to press
"

dialog --title "🎉 Finished setting up" --msgbox "$success_message" 20 60 