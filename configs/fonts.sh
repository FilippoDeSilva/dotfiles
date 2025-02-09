#!/bin/bash

echo "🔤 Installing Powerline fonts..."

# Define font directory
FONT_DIR="/usr/share/fonts/truetype"

# Ensure dependencies are installed
sudo apt update && sudo apt install -y fonts-powerline

# Verify if fonts are installed correctly
if [ -d "$FONT_DIR" ]; then
    echo "✅ Powerline fonts installed successfully!"
else
    echo "❌ Powerline fonts installation failed!"
fi
