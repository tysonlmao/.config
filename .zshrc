# tysonlmao zshrc
# V2025.04.07

if command -v tmux &> /dev/null && [[ ! $TERM =~ screen ]] && [[ ! $TERM =~ tmux ]] && [[ -z "$TMUX" ]]; then
  tmux attach -t default || tmux new -s default
fi

case $TERM in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
esac

alias 'zshprofile'='source ~/.config/.zshrc'
alias 'll'='ls -alX'

# cargo export
. "$HOME/.cargo/env"

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Git branch parsing
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

# Prompt colors
COLOR_DEF=$'%f'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'

# Enable prompt substitution
setopt PROMPT_SUBST

# Set prompt
PROMPT='${COLOR_USR}%n ${COLOR_DIR}%~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF} $ '
