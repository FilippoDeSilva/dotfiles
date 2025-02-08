#!/bin/bash

# Ensure the script is run with sudo if necessary
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Update and upgrade system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install essential packages for all users
echo "Installing essential packages..."
sudo apt install -y zsh tmux alacritty git curl fontconfig zoxide

# Install Oh My Zsh for all users (only if it's not already installed)
echo "Installing Oh My Zsh..."
if [[ ! -d "/root/.oh-my-zsh" ]]; then
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme for Zsh (only if it's not already installed)
echo "Installing Powerlevel10k..."
if [[ ! -d "/usr/share/powerlevel10k" ]]; then
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/share/powerlevel10k
else
    echo "Powerlevel10k is already installed."
fi

# Install zsh plugins: zsh-autosuggestions and zsh-syntax-highlighting (only if not already installed)
echo "Installing zsh plugins..."
# Install zsh-autosuggestions
if [[ ! -d "/usr/share/oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
    sudo git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/oh-my-zsh/custom/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions is already installed."
fi

# Install zsh-syntax-highlighting
if [[ ! -d "/usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting /usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting is already installed."
fi

# Set default shell to zsh for all users
echo "Changing default shell to Zsh for all users..."
for user in $(getent passwd | awk -F: '{print $1}'); do
    sudo chsh -s $(which zsh) "$user"
done

# Copy the .zshrc file to each user's home directory
echo "Copying .zshrc to all users..."

# Path to the template .zshrc file (adjust if the file is elsewhere)
TEMPLATE_ZSHRC=".zshrc"

# Check if the .zshrc template exists
if [[ ! -f "$TEMPLATE_ZSHRC" ]]; then
    echo "Error: .zshrc template not found!"
    exit 1
fi

# Copy the .zshrc template to each user's home directory
for user in $(getent passwd | awk -F: '{print $1}'); do
    USER_HOME=$(eval echo ~$user)

    # Skip system users, users without a home directory, and invalid user entries
    if [[ ! -d "$USER_HOME" || "$user" == "root" || "$user" == "sync" || "$user" == "_apt" || "$user" == "nobody" || "$USER_HOME" == "/proc" ]]; then
        continue
    fi

    # Fetch the user's group dynamically
    USER_GROUP=$(id -gn $user)

    # Make a backup of the old .zshrc if it exists
    if [[ -f "$USER_HOME/.zshrc" ]]; then
        sudo mv "$USER_HOME/.zshrc" "$USER_HOME/.zshrc.backup"
    fi

    # Copy the template .zshrc file to the user's home directory
    sudo cp "$TEMPLATE_ZSHRC" "$USER_HOME/.zshrc"

    # Set correct ownership based on the user's primary group
    sudo chown $user:$USER_GROUP "$USER_HOME/.zshrc"
done

# Install Powerline fonts manually for Powerlevel10k
echo "Installing Powerline-compatible fonts manually for Powerlevel10k..."

# Download and install Powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts
sudo /tmp/fonts/install.sh
rm -rf /tmp/fonts

# Final reminder to run Powerlevel10k setup for every user
echo "Powerlevel10k installed. Run 'p10k configure' to customize the prompt for each user."

# Suggest restarting the terminal for every user
echo "Setup complete. Please restart your terminal for all users to apply the changes."

# Install and configure tmux

# Check if tmux.conf file exists
TEMPLATE_TMUX_CONF="tmux.conf"

if [[ ! -f "$TEMPLATE_TMUX_CONF" ]]; then
    echo "Error: tmux.conf template not found!"
    exit 1
fi

# Copy the tmux.conf file to each user's home directory
echo "Copying tmux.conf to all users..."

for user in $(getent passwd | awk -F: '{print $1}'); do
    USER_HOME=$(eval echo ~$user)

    # Skip system users, users without a home directory, and invalid user entries
    if [[ ! -d "$USER_HOME" || "$user" == "root" || "$user" == "sync" || "$user" == "_apt" || "$user" == "nobody" || "$USER_HOME" == "/proc" ]]; then
        continue
    fi

    # Fetch the user's group dynamically
    USER_GROUP=$(id -gn $user)

    # Make a backup of the old .tmux.conf if it exists
    if [[ -f "$USER_HOME/.tmux.conf" ]]; then
        sudo mv "$USER_HOME/.tmux.conf" "$USER_HOME/.tmux.conf.backup"
    fi

    # Copy the template tmux.conf file to the user's home directory
    sudo cp "$TEMPLATE_TMUX_CONF" "$USER_HOME/.tmux.conf"

    # Set correct ownership based on the user's primary group
    sudo chown $user:$USER_GROUP "$USER_HOME/.tmux.conf"
done

# End of script
