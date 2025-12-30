# Zero-Drag Zsh Configuration

# Initialize Starship Prompt
eval "$(starship init zsh)"

# Aliases
alias ll='ls -al'
alias ..='cd ..'
alias v='vim'  # Using vim as requested/default, user can change to nvim if installed
alias c='clear'
alias gs='git status'

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY
