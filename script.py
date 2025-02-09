#!/usr/bin/env python3
import os
import shutil
import subprocess
from pathlib import Path

# Set the configuration directory (this script assumes the config files are in the "config_files" folder)
CONFIG_DIR = Path(__file__).parent / "configs"

# Define the configuration files
ZSHRC_FILE      = CONFIG_DIR / ".zshrc"
P10K_FILE       = CONFIG_DIR / ".p10k.zsh"
TMUX_CONF_FILE  = CONFIG_DIR / ".tmux.conf"
ALACRITTY_FILE  = CONFIG_DIR / "alacritty.yml"  # Optional (for Alacritty)

def run_command(cmd, use_sudo=False):
    """
    Run a shell command.
    If use_sudo is True, run it under 'sudo bash -c'.
    """
    full_cmd = cmd if not use_sudo else f"sudo bash -c '{cmd}'"
    try:
        result = subprocess.run(full_cmd, shell=True, capture_output=True, text=True, check=True)
        print(f"✅ {cmd}")
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"❌ Error executing command: {cmd}")
        print(e.stderr)
        return None

def install_packages():
    print("Installing necessary packages...")
    # Removed 'exa' as it may not be available via apt on your system.
    packages = "zsh tmux alacritty git curl bat ripgrep fzf zoxide"
    run_command(f"apt update && apt install -y {packages}", use_sudo=True)

def install_oh_my_zsh():
    if not Path("/usr/share/oh-my-zsh").exists():
        print("Installing Oh My Zsh system-wide...")
        run_command("git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh", use_sudo=True)
    else:
        print("Oh My Zsh is already installed.")

def install_powerlevel10k():
    theme_path = Path("/usr/share/oh-my-zsh/custom/themes/powerlevel10k")
    if not theme_path.exists():
        print("Installing Powerlevel10k theme...")
        run_command(f"git clone --depth=1 https://github.com/romkatv/powerlevel10k.git {theme_path}", use_sudo=True)
    else:
        print("Powerlevel10k is already installed.")

def install_fonts():
    print("Installing Nerd Fonts and Powerline fonts...")
    # Use a timeout of 60 seconds to prevent hanging indefinitely.
    clone_cmd = "timeout 60 git clone https://github.com/ryanoasis/nerd-fonts.git --depth=1 /tmp/nerd-fonts"
    clone_result = run_command(clone_cmd, use_sudo=True)
    if clone_result is None:
        print("❌ Failed to clone Nerd Fonts repository (network issues or broken link).")
        print("Skipping Nerd Fonts installation. You can install them manually if desired.")
    else:
        run_command("/tmp/nerd-fonts/install.sh", use_sudo=True)
        run_command("rm -rf /tmp/nerd-fonts", use_sudo=True)

def copy_config_files():
    # Get all users with a home directory in /home, then add root.
    users = os.popen("getent passwd | awk -F: '{if ($6 ~ /^\\/home\\//) print $1}'").read().splitlines()
    users.append("root")
    for user in users:
        if not user:
            continue
        home = Path(f"/home/{user}") if user != "root" else Path("/root")
        if not home.exists():
            continue
        print(f"Copying configuration files to {home}...")
        shutil.copy(ZSHRC_FILE, home / ".zshrc")
        shutil.copy(P10K_FILE, home / ".p10k.zsh")
        shutil.copy(TMUX_CONF_FILE, home / ".tmux.conf")
        if ALACRITTY_FILE.exists():
            alacritty_dir = home / ".config" / "alacritty"
            alacritty_dir.mkdir(parents=True, exist_ok=True)
            shutil.copy(ALACRITTY_FILE, alacritty_dir / "alacritty.yml")
        # Set ownership so that the user owns the copied files.
        run_command(f"chown {user}:{user} {home}/.zshrc", use_sudo=True)
        run_command(f"chown {user}:{user} {home}/.p10k.zsh", use_sudo=True)
        run_command(f"chown {user}:{user} {home}/.tmux.conf", use_sudo=True)
        if ALACRITTY_FILE.exists():
            run_command(f"chown -R {user}:{user} {home}/.config/alacritty", use_sudo=True)

def set_default_shell():
    print("Setting Zsh as the default shell for all users...")
    run_command("chsh -s $(which zsh) root", use_sudo=True)
    users = os.popen("getent passwd | awk -F: '{if ($6 ~ /^\\/home\\//) print $1}'").read().splitlines()
    for user in users:
        run_command(f"chsh -s $(which zsh) {user}", use_sudo=True)

def main():
    install_packages()
    install_oh_my_zsh()
    install_powerlevel10k()
    install_fonts()
    copy_config_files()
    set_default_shell()
    print("Terminal setup complete! Please restart your terminal.")

if __name__ == "__main__":
    main()
