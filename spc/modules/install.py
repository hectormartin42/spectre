import subprocess
import sys

# Tools not in official Arch repos — installed via AUR (yay) or pip
AUR_TOOLS = {
    "ffuf":         {"aur": "ffuf",             "desc": "Fast web fuzzer"},
    "nuclei":       {"aur": "nuclei-bin",       "desc": "Template-based vulnerability scanner"},
    "theharvester": {"aur": "theharvester",     "desc": "Email & subdomain harvesting"},
    "recon-ng":     {"aur": "recon-ng",         "desc": "Web reconnaissance framework"},
    "whatweb":      {"aur": "whatweb",          "desc": "Web fingerprinting"},
    "netdiscover":  {"aur": "netdiscover",      "desc": "ARP network scanner"},
    "sherlock":     {"pip": "sherlock-project",  "desc": "Username OSINT across 300+ sites"},
    "holehe":       {"pip": "holehe",           "desc": "Email OSINT"},
    "pwncat":       {"pip": "pwncat-cs",        "desc": "Reverse/bind shell handler"},
    "seclists":     {"aur": "seclists",         "desc": "Security wordlists collection"},
    "wordlists":    {"aur": "wordlists",        "desc": "Common wordlists"},
    "crunch":       {"aur": "crunch",           "desc": "Wordlist generator"},
    "autopsy":      {"aur": "autopsy",          "desc": "Digital forensics platform"},
    "dirbuster":    {"aur": "dirbuster",        "desc": "Web directory brute-forcer"},
    "chisel":       {"aur": "chisel-bin",       "desc": "TCP/UDP tunneling over HTTP"},
    "evil-winrm":   {"aur": "evil-winrm",       "desc": "Windows remote management shell"},
    "crackmapexec": {"aur": "crackmapexec",     "desc": "SMB/AD enumeration"},
    "ligolo-ng":    {"aur": "ligolo-ng-bin",    "desc": "Reverse tunneling agent"},
}

BLACKARCH_TOOLS = {
    "burpsuite": {"pkg": "burpsuite", "desc": "Web proxy & scanner"},
    "maltego":   {"pkg": "maltego",   "desc": "Link analysis & OSINT"},
}


def install_tool(name: str):
    tool = AUR_TOOLS.get(name) or BLACKARCH_TOOLS.get(name)
    if tool is None:
        print(f"\033[31m[!] Unknown tool '{name}'\033[0m")
        list_tools()
        sys.exit(1)

    print(f"\033[32m[*] Installing {name}\033[0m — {tool['desc']}")

    if "pip" in tool:
        _run(["pip", "install", "--user", tool["pip"]])
    elif "aur" in tool:
        _ensure_yay()
        _run(["yay", "-S", "--noconfirm", tool["aur"]])
    elif "pkg" in tool:
        _ensure_blackarch()
        _run(["sudo", "pacman", "-S", "--noconfirm", tool["pkg"]])


def install_all():
    print("\033[32m[*] Installing all Spectre extra tools...\033[0m\n")
    _ensure_yay()
    for name, tool in AUR_TOOLS.items():
        print(f"\033[90m  → {name}\033[0m")
        if "pip" in tool:
            _run(["pip", "install", "--user", "--quiet", tool["pip"]])
        elif "aur" in tool:
            _run(["yay", "-S", "--noconfirm", "--needed", tool["aur"]])
    print("\n\033[32m[+] Done.\033[0m")


def list_tools():
    print("\033[32m[*] Extra tools (AUR/pip — not in base ISO):\033[0m\n")
    all_tools = {**AUR_TOOLS, **BLACKARCH_TOOLS}
    for name, info in all_tools.items():
        src = "AUR" if "aur" in info else ("pip" if "pip" in info else "BlackArch")
        print(f"  \033[1m{name:<18}\033[0m \033[90m[{src}]\033[0m  {info['desc']}")
    print()
    print(f"  Install one:  \033[36mspc install <tool>\033[0m")
    print(f"  Install all:  \033[36mspc install --all\033[0m\n")


def _run(cmd: list):
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError:
        print(f"\033[31m[!] Failed: {' '.join(cmd)}\033[0m")
    except FileNotFoundError:
        print(f"\033[31m[!] Command not found: {cmd[0]}\033[0m")


def _ensure_yay():
    if subprocess.run(["which", "yay"], capture_output=True).returncode == 0:
        return
    print("\033[33m[~] yay not found — installing...\033[0m")
    cmds = [
        ["sudo", "pacman", "-S", "--noconfirm", "git", "base-devel"],
        ["git", "clone", "https://aur.archlinux.org/yay.git", "/tmp/yay"],
        ["bash", "-c", "cd /tmp/yay && makepkg -si --noconfirm"],
    ]
    for cmd in cmds:
        _run(cmd)


def _ensure_blackarch():
    import os
    if "blackarch" in open("/etc/pacman.conf").read():
        return
    print("\033[33m[~] Adding BlackArch repo...\033[0m")
    _run(["bash", "-c", "curl -s https://blackarch.org/strap.sh | sudo bash"])
