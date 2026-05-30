#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
#  Spectre OS — ISO Build System
#  Requires: archiso (pacman -S archiso)
#  Usage: sudo bash iso/build.sh
# ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$SCRIPT_DIR/profile"
WORK_DIR="/tmp/spectre-work"
OUT_DIR="$REPO_DIR/out"
ISO_NAME="spectre-os"
ISO_VERSION="0.1.0"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

log()  { echo -e "${GREEN}[*]${RESET} $*"; }
info() { echo -e "${CYAN}[~]${RESET} $*"; }
die()  { echo -e "${RED}[!]${RESET} $*"; exit 1; }

# ── Checks ────────────────────────────────────────────────────
[[ "$EUID" -ne 0 ]] && die "Run as root: sudo bash iso/build.sh"
command -v mkarchiso &>/dev/null || die "archiso not found. Install with: pacman -S archiso"

log "Building Spectre OS v${ISO_VERSION}"
log "Profile: $PROFILE_DIR"

# ── Clean previous build ──────────────────────────────────────
if [[ -d "$WORK_DIR" ]]; then
    info "Cleaning previous work dir..."
    rm -rf "$WORK_DIR"
fi
mkdir -p "$OUT_DIR"

# ── Build ─────────────────────────────────────────────────────
log "Starting mkarchiso..."
mkarchiso \
    -v \
    -w "$WORK_DIR" \
    -o "$OUT_DIR" \
    "$PROFILE_DIR"

ISO_FILE=$(find "$OUT_DIR" -name "*.iso" | head -1)
log "ISO built: $ISO_FILE"

# ── Checksum ──────────────────────────────────────────────────
sha256sum "$ISO_FILE" > "${ISO_FILE}.sha256"
log "SHA256: $(cat "${ISO_FILE}.sha256")"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║   Spectre OS ISO ready!                              ║${RESET}"
echo -e "${GREEN}║   $(basename "$ISO_FILE")                            ║${RESET}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  Test with QEMU:"
echo -e "  ${CYAN}qemu-system-x86_64 -m 2G -cdrom $ISO_FILE -boot d${RESET}"
