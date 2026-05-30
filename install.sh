#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
#  Spectre OS — Bootstrap Installer
#  github.com/hectormartin42/spectre
# ─────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

BANNER="
  ██████  ██▓███  ▓█████  ▄████▄  ▄▄▄█████▓ ██▀███  ▓█████
▒██    ▒ ▓██░  ██▒▓█   ▀ ▒██▀ ▀█  ▓  ██▒ ▓▒▓██ ▒ ██▒▓█   ▀
░ ▓██▄   ▓██░ ██▓▒▒███   ▒▓█    ▄ ▒ ▓██░ ▒░▓██ ░▄█ ▒▒███
  ▒   ██▒▒██▄█▓▒ ▒▒▓█  ▄ ▒▓▓▄ ▄██▒░ ▓██▓ ░ ▒██▀▀█▄  ▒▓█  ▄
▒██████▒▒▒██▒ ░  ░░▒████▒▒ ▓███▀ ░  ▒██▒ ░ ░██▓ ▒██▒░▒████▒
"

echo -e "${GREEN}${BANNER}${RESET}"
echo -e "${CYAN}  Spectre OS Installer — v0.1.0${RESET}\n"

# ── Detect distro ─────────────────────────────
detect_distro() {
    if command -v pacman &>/dev/null; then echo "arch"
    elif command -v apt-get &>/dev/null; then echo "debian"
    else echo "unknown"
    fi
}

DISTRO=$(detect_distro)

if [[ "$DISTRO" == "unknown" ]]; then
    echo -e "${RED}[!] Unsupported distro. Spectre supports Arch and Debian-based systems.${RESET}"
    exit 1
fi

echo -e "${GREEN}[*] Detected: ${DISTRO}${RESET}"

# ── Package install helpers ───────────────────
install_pkg_arch() {
    sudo pacman -Sy --noconfirm "$@"
}

install_pkg_debian() {
    sudo apt-get install -y "$@"
}

install_pkg() {
    if [[ "$DISTRO" == "arch" ]]; then install_pkg_arch "$@"
    else install_pkg_debian "$@"
    fi
}

# ── Core dependencies ─────────────────────────
echo -e "\n${CYAN}[*] Installing core dependencies...${RESET}"
CORE_PKGS=(git python3 python3-pip tmux curl wget nmap)
install_pkg "${CORE_PKGS[@]}"

# ── Python CLI (spc) ──────────────────────────
echo -e "\n${CYAN}[*] Installing spc CLI...${RESET}"
pip3 install --user click

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pip3 install --user -e "$REPO_DIR"

# ── Security tools ────────────────────────────
echo -e "\n${CYAN}[*] Installing security tools...${RESET}"

if [[ "$DISTRO" == "arch" ]]; then
    # Enable BlackArch repo if not already enabled
    if ! grep -q "blackarch" /etc/pacman.conf 2>/dev/null; then
        echo -e "${YELLOW}[*] Adding BlackArch repository...${RESET}"
        curl -s https://blackarch.org/strap.sh | sudo bash
    fi
    SEC_PKGS=(nmap wireshark-qt sqlmap ffuf nuclei gobuster theHarvester
              metasploit exploitdb burpsuite hydra hashcat john wordlists)
    install_pkg_arch "${SEC_PKGS[@]}" 2>/dev/null || true
else
    SEC_PKGS=(nmap wireshark sqlmap hydra hashcat john wordlists exploitdb)
    install_pkg_debian "${SEC_PKGS[@]}" 2>/dev/null || true
fi

# ── Shell config ──────────────────────────────
echo -e "\n${CYAN}[*] Configuring shell...${RESET}"
FISH_CONF_DIR="$HOME/.config/fish"
mkdir -p "$FISH_CONF_DIR"

if [[ ! -f "$FISH_CONF_DIR/config.fish" ]] || ! grep -q "spectre" "$FISH_CONF_DIR/config.fish"; then
    cat >> "$FISH_CONF_DIR/config.fish" <<'EOF'

# ── Spectre ───────────────────────────────────
set -x SPECTRE_HOME "$HOME/.spectre"
set -x PATH "$HOME/.local/bin" $PATH
alias spc='spc'
EOF
fi

# ── Dotfiles ──────────────────────────────────
echo -e "\n${CYAN}[*] Applying Spectre dotfiles...${RESET}"
CONFIG_SRC="$REPO_DIR/config"

link_config() {
    local src="$CONFIG_SRC/$1"
    local dst="$HOME/.config/$2"
    if [[ -d "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        ln -sfn "$src" "$dst"
        echo -e "  ${GREEN}✓${RESET} ~/.config/$2"
    fi
}

link_config "kitty"   "kitty"
link_config "fish"    "fish/conf.d/spectre.fish"
link_config "i3"      "i3"
link_config "hypr"    "hypr"

# ── Done ──────────────────────────────────────
echo -e "\n${GREEN}╔══════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║     Spectre installed successfully!      ║${RESET}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${RESET}\n"
echo -e "  Run ${CYAN}spc${RESET} to get started"
echo -e "  Run ${CYAN}spc workspace web${RESET} to launch your first workspace\n"
