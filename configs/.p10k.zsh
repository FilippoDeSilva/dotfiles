# Minimal Powerlevel10k configuration for a modern look

# Left prompt: current directory and Git status
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

# Right prompt: job status and time
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time)

# Display prompt on a new line with a custom prefix
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{cyan}╭─%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{cyan}╰─%f "

# Shorten directory display
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
