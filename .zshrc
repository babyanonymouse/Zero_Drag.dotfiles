# Zero-Drag Zsh Configuration
# Optimized for Performance & Ergonomics

# 1. Environment Variables
export EDITOR='vim'
export VISUAL='vim'
export PAGER='bat'

# 2. Keybindings (Fixing Kitty/Termite/Alacritty quirks)
bindkey -e  # Emacs mode

# History Search (Ctrl+R replacement using FZF if available, else default)
if command -v fzf &> /dev/null; then
  source /usr/share/zsh/plugins/fzf/fzf.plugin.zsh 2>/dev/null || true
  bindkey '^R' fzf-history-widget
fi

# Standard Navigation
bindkey "^[[H" beginning-of-line       # Home
bindkey "^[[F" end-of-line             # End
bindkey "^[[3~" delete-char            # Delete
bindkey "^[[1;5C" forward-word         # Ctrl+Right
bindkey "^[[1;5D" backward-word        # Ctrl+Left
bindkey "^H" backward-kill-word        # Ctrl+Backspace (Critical fix)

# 3. Modern Tool Integration
# Initialize zoxide (smarter cd)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# 4. Plugins
# Source official Arch Linux plugin paths
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source /usr/share/zsh/plugins/zsh-completions/zsh-completions.zsh 2>/dev/null || true

# 5. Aliases
# File System (eza)
if command -v eza &> /dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -al --icons --group-directories-first'
  alias tree='eza --tree --icons'
else
  alias ll='ls -al'
fi

# Cat (bat)
if command -v bat &> /dev/null; then
  alias cat='bat'
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias cd='z' # Use zoxide by default

# Utils
alias v='vim'
alias c='clear'
alias gs='git status'
alias grep='rg' # Use ripgrep by default

# 6. History Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# 7. Prompt (Must be last)
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# 8. Transient Prompt
# Collapses the prompt to a simple '➜' after command execution
zle-line-finish() {
  # %B = bold, %F{green} = green foreground, %f = reset color, %b = reset bold
  PROMPT='%B%F{green}➜%f%b '
  RPROMPT=''
  zle reset-prompt
}
zle -N zle-line-finish
