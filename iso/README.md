# ISO Build

Spectre OS ISOs are built with [archiso](https://wiki.archlinux.org/title/Archiso).

## Requirements

- Arch Linux host (or container)
- `archiso` package
- Root privileges

## Build

```bash
# Install archiso
sudo pacman -S archiso

# Build the ISO
sudo bash iso/build.sh
```

Output lands in `out/spectre-os-*.iso`.

## Test with QEMU

```bash
qemu-system-x86_64 \
    -m 4G \
    -cdrom out/spectre-os-*.iso \
    -boot d \
    -enable-kvm \
    -vga virtio
```

## Write to USB

```bash
sudo dd if=out/spectre-os-*.iso of=/dev/sdX bs=4M status=progress && sync
```

## Boot options

| Entry | Description |
|-------|-------------|
| **Spectre OS (default)** | Normal live environment |
| **Forensics Mode** | No swap, no automount — safe for evidence collection |
| **Memory Test** | memtest86+ |

## Profile structure

```
iso/profile/
├── profiledef.sh          # ISO metadata
├── packages.x86_64        # Package list
├── airootfs/              # Files overlaid onto the live system
│   ├── etc/
│   │   ├── os-release
│   │   ├── spectre/release
│   │   └── systemd/system/spectre-setup.service
│   ├── root/
│   │   └── .zshrc
│   └── usr/local/bin/
│       └── spectre-setup  # First-boot script
├── efiboot/               # UEFI boot config
│   └── loader/entries/
└── syslinux/              # Legacy BIOS boot config
    └── syslinux.cfg
```
