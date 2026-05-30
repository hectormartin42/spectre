<div align="center">

```
  ██████  ██▓███  ▓█████  ▄████▄  ▄▄▄█████▓ ██▀███  ▓█████
▒██    ▒ ▓██░  ██▒▓█   ▀ ▒██▀ ▀█  ▓  ██▒ ▓▒▓██ ▒ ██▒▓█   ▀
░ ▓██▄   ▓██░ ██▓▒▒███   ▒▓█    ▄ ▒ ▓██░ ▒░▓██ ░▄█ ▒▒███
  ▒   ██▒▒██▄█▓▒ ▒▒▓█  ▄ ▒▓▓▄ ▄██▒░ ▓██▓ ░ ▒██▀▀█▄  ▒▓█  ▄
▒██████▒▒▒██▒ ░  ░░▒████▒▒ ▓███▀ ░  ▒██▒ ░ ░██▓ ▒██▒░▒████▒
```

**A next-generation cybersecurity & pentesting OS built for real-world engagements.**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.1.0-cyan.svg)](https://github.com/hectormartin42/spectre/releases)
[![Platform](https://img.shields.io/badge/platform-Arch%20%7C%20Debian-blue.svg)](#installation)
[![CI](https://github.com/hectormartin42/spectre/actions/workflows/ci.yml/badge.svg)](https://github.com/hectormartin42/spectre/actions)

</div>

---

## Why Spectre?

Most pentesting distros are just bloated tool collections with no workflow. Spectre is different:

- **Mission workspaces** — launch a fully configured environment in one command
- **`spc` CLI** — a unified tool that ties scanning, notes, and reporting together
- **Curated, not bloated** — every tool is there for a reason
- **Reproducible** — install on any Arch or Debian system in minutes

---

## Quick Install

```bash
curl -s https://raw.githubusercontent.com/hectormartin42/spectre/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/hectormartin42/spectre
cd spectre
bash install.sh
```

---

## The `spc` CLI

```
spc <command> [options]

Commands:
  scan        Run a network scan against a target
  workspace   Launch a preconfigured hacking workspace
  note        Manage engagement notes
  report      Generate a report from engagement notes
  banner      Print Spectre banner
```

### Scan

```bash
spc scan --target 192.168.1.0/24 --profile stealth
spc scan -t 10.10.10.1 --profile aggressive --ports 1-65535
spc scan -t example.com --profile quick -o client_recon
```

**Profiles:**

| Profile | Flags | Use case |
|---------|-------|----------|
| `stealth` | -sS -T2 -f --data-length 24 | Evade IDS |
| `normal` | -sV -sC -T3 | Standard recon |
| `aggressive` | -sV -sC -T4 -A --script=vuln | Full audit |
| `quick` | -sV -T4 --open | Fast overview |

### Workspaces

```bash
spc workspace web        # Burp, ffuf, nuclei, sqlmap, gobuster
spc workspace network    # nmap, wireshark, responder, crackmapexec
spc workspace red-team   # metasploit, chisel, ligolo-ng, evil-winrm
spc workspace osint      # theHarvester, maltego, shodan, recon-ng
spc workspace forensics  # volatility3, ghidra, binwalk, autopsy
```

Each workspace opens a tmux layout with tools ready and your notes visible.

### Notes & Reporting

```bash
# Take notes during an engagement
spc note add "Found SQLi on /login" --tag sqli --engagement client_x
spc note add "Admin creds: admin:password123" --tag cred -e client_x
spc note list --engagement client_x

# Generate a report
spc report --engagement client_x --format md
spc report -e client_x -f txt -o final_report
```

---

## Environment

Spectre ships with a pre-configured desktop environment:

| Component | Choice |
|-----------|--------|
| WM | i3-gaps / Hyprland |
| Terminal | Kitty |
| Shell | Fish |
| Fonts | JetBrainsMono Nerd Font |
| Color scheme | Dark + neon green/cyan |

---

## Tool Arsenal

<details>
<summary><b>Web</b></summary>

- Burp Suite — web proxy & scanner
- ffuf — fast fuzzer
- nuclei — template-based scanner
- sqlmap — SQL injection automation
- gobuster — directory/DNS brute-force
- whatweb — web fingerprinting

</details>

<details>
<summary><b>Network</b></summary>

- nmap — port scanning & service detection
- wireshark — packet analysis
- responder — LLMNR/NBT-NS poisoning
- crackmapexec — SMB/AD enumeration
- netdiscover — ARP reconnaissance

</details>

<details>
<summary><b>Red Team</b></summary>

- Metasploit — exploitation framework
- Chisel — TCP/UDP tunneling
- Ligolo-ng — reverse tunneling
- Evil-WinRM — Windows remote management

</details>

<details>
<summary><b>OSINT</b></summary>

- theHarvester — email & subdomain harvesting
- Maltego — link analysis
- Recon-ng — web reconnaissance framework
- Sherlock — username OSINT
- Holehe — email OSINT

</details>

<details>
<summary><b>Forensics</b></summary>

- Volatility 3 — memory forensics
- Autopsy — disk forensics
- Ghidra — reverse engineering
- Binwalk — firmware analysis
- Foremost — file carving

</details>

---

## Roadmap

- [ ] ISO build system (archiso-based)
- [ ] Hyprland config + animations
- [ ] `spc target` — engagement target management
- [ ] `spc payload` — payload generation shortcuts
- [ ] `spc vpn` — HTB/THM VPN management
- [ ] Web dashboard for engagement reports
- [ ] Package manager: `spc install <tool>`
- [ ] Docker support for isolated tool environments

---

## Contributing

Pull requests are welcome. For major changes, open an issue first.

1. Fork the repo
2. Create your branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Open a PR

---

## Legal

Spectre is intended for authorized security testing, CTF competitions, and educational use only. The authors are not responsible for misuse.

---

<div align="center">
<sub>Built with ☠️ by <a href="https://github.com/hectormartin42">hectormartin42</a> — stay invisible</sub>
</div>
