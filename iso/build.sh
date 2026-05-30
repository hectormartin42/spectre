#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
#  Spectre OS — ISO Build System
#  Requires: archiso (pacman -S archiso)
#  Usage: sudo bash iso/build.sh
# ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
WORK_DIR="/tmp/spectre-work"
OUT_DIR="$REPO_DIR/out"
PROFILE_DIR="$WORK_DIR/profile"
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

ARCHISO_RELENG="/usr/share/archiso/configs/releng"
[[ -d "$ARCHISO_RELENG" ]] || die "archiso releng profile not found at $ARCHISO_RELENG"

log "Building Spectre OS v${ISO_VERSION}"

# ── Clean previous build ──────────────────────────────────────
[[ -d "$WORK_DIR" ]] && { info "Cleaning previous work dir..."; rm -rf "$WORK_DIR"; }
mkdir -p "$WORK_DIR" "$OUT_DIR"

# ── Start from archiso releng baseline ───────────────────────
log "Copying archiso releng baseline..."
cp -r "$ARCHISO_RELENG" "$PROFILE_DIR"

# ── Overlay Spectre customizations ───────────────────────────
log "Applying Spectre customizations..."

# profiledef.sh — identity
cat > "$PROFILE_DIR/profiledef.sh" <<'EOF'
#!/usr/bin/env bash
iso_name="spectre-os"
iso_label="SPECTRE_OS"
iso_publisher="Spectre OS <https://github.com/hectormartin42/spectre>"
iso_application="Spectre OS — Cybersecurity & Pentesting"
iso_version="0.1.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/usr/local/bin/spectre-setup"]="0:0:755"
)
EOF

# os-release — Spectre identity
cat > "$PROFILE_DIR/airootfs/etc/os-release" <<'EOF'
NAME="Spectre OS"
PRETTY_NAME="Spectre OS 0.1.0 (Phantom)"
ID=spectre
ID_LIKE=arch
VERSION="0.1.0"
VERSION_CODENAME=phantom
HOME_URL="https://github.com/hectormartin42/spectre"
BUG_REPORT_URL="https://github.com/hectormartin42/spectre/issues"
ANSI_COLOR="1;32"
EOF

# Merge our packages into the package list
log "Merging Spectre package list..."
SPECTRE_PKGS="$SCRIPT_DIR/profile/packages.x86_64"
if [[ -f "$SPECTRE_PKGS" ]]; then
    # Append spectre packages (skip comments and blanks already in base list)
    grep -v '^\s*#' "$SPECTRE_PKGS" | grep -v '^\s*$' >> "$PROFILE_DIR/packages.x86_64" || true
    # Deduplicate
    sort -u "$PROFILE_DIR/packages.x86_64" -o "$PROFILE_DIR/packages.x86_64"
fi

# Copy airootfs overlays
log "Copying airootfs overlays..."
cp -r "$SCRIPT_DIR/profile/airootfs/." "$PROFILE_DIR/airootfs/"

# Copy spc CLI into the live system
log "Embedding spc CLI..."
mkdir -p "$PROFILE_DIR/airootfs/opt/spectre"
cp -r "$REPO_DIR/spc" "$PROFILE_DIR/airootfs/opt/spectre/"
cp "$REPO_DIR/setup.py" "$PROFILE_DIR/airootfs/opt/spectre/"
cp -r "$REPO_DIR/workspaces" "$PROFILE_DIR/airootfs/opt/spectre/"
cp -r "$REPO_DIR/config" "$PROFILE_DIR/airootfs/opt/spectre/"

# Root shell: fish + spc banner on login
mkdir -p "$PROFILE_DIR/airootfs/root"
cat >> "$PROFILE_DIR/airootfs/root/.bash_profile" <<'EOF'

# Spectre
export PATH="$HOME/.local/bin:/opt/spectre:$PATH"
export SPECTRE_HOME="$HOME/.spectre"
cd /root
EOF

# ── Build ─────────────────────────────────────────────────────
log "Starting mkarchiso..."
mkarchiso -v -w "$WORK_DIR/build" -o "$OUT_DIR" "$PROFILE_DIR"

ISO_FILE=$(find "$OUT_DIR" -name "*.iso" | head -1)
[[ -z "$ISO_FILE" ]] && die "ISO not found in $OUT_DIR"

log "ISO built: $ISO_FILE"

# ── Checksum ──────────────────────────────────────────────────
sha256sum "$ISO_FILE" > "${ISO_FILE}.sha256"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║   Spectre OS ISO ready!                              ║${RESET}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${CYAN}$(basename "$ISO_FILE")${RESET}"
echo -e "  SHA256: $(cut -d' ' -f1 "${ISO_FILE}.sha256")"
echo ""
echo -e "  Test with QEMU:"
echo -e "  ${CYAN}qemu-system-x86_64 -m 2G -cdrom \"$ISO_FILE\" -boot d -enable-kvm${RESET}"
