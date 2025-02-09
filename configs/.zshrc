# Unified .zshrc for all users

# Use system-wide Oh My Zsh and custom themes
export ZSH="/usr/share/oh-my-zsh"
export ZSH_CUSTOM="/usr/share/oh-my-zsh/custom"

# Set Powerlevel10k as the theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# List of plugins to load
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf zoxide)

# Load Oh My Zsh
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
else
  echo "Warning: Oh My Zsh not found!"
fi

# Load user Powerlevel10k configuration if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Set alias for ls: if exa exists, use it; otherwise, use ls with color.
if command -v exa > /dev/null; then
    alias ls="exa --icons --group-directories-first"
else
    alias ls="ls --color=auto"
fi

alias ll="ls -lh"
alias la="ls -lah"

# Other productivity aliases
alias cat="bat --style=plain"
alias grep="rg"

# Set terminal to support 256 colors
export TERM="xterm-256color"
