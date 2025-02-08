# Path to your Oh My Zsh installation (use a system-wide path for all users)
if [[ $EUID -eq 0 ]]; then
  # For root user, use a system-wide path for plugins and theme
  export ZSH="/usr/share/oh-my-zsh"
  export POWERLEVEL10K_DIR="/usr/share/powerlevel10k"
  export ZSH_CUSTOM="/usr/share/oh-my-zsh/custom"
else
  # For normal users, use their home directory for Oh My Zsh and Powerlevel10k
  export ZSH="$HOME/.oh-my-zsh"
  export POWERLEVEL10K_DIR="$HOME/powerlevel10k"
  export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
fi

# Disable instant prompt to avoid warning
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Set the PATH to include local binaries.
export PATH="$HOME/.local/bin:$PATH"

# Enable zoxide for directory navigation (ensure zoxide is installed).
eval "$(zoxide init zsh)"

# Configure terminal to support 256 colors and ensure compatibility with backspace.
export TERM=xterm-256color
stty erase ^H  # Fix backspace issue in zsh

# Enable real-time command suggestions with zsh-autosuggestions.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh.
source $ZSH/oh-my-zsh.sh

# Powerlevel10k Instant Prompt (you can disable it if you want to avoid the prompt delay).
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k Theme for prompt customization.
source "$POWERLEVEL10K_DIR/powerlevel10k.zsh-theme"

# Enable autosuggestions key binding.
bindkey '^[[Z' autosuggest-accept

# Disable ASCII art or pixel images on terminal startup.
unset PROMPT_COMMAND

# To customize the prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load zsh-syntax-highlighting plugin dynamically based on user
if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -d "/usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
  source "/usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  echo "Error: zsh-syntax-highlighting plugin not found!"
fi

# Launch tmux if it's not already running
if [[ -z "$TMUX" ]]; then
    tmux new-session -d -s main
    tmux attach-session -t main
fi
