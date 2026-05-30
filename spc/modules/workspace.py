import os
import subprocess
import sys

WORKSPACES = {
    "web": {
        "desc": "Web application pentesting — Burp, ffuf, nuclei, sqlmap",
        "tools": ["burpsuite", "ffuf", "nuclei", "sqlmap", "gobuster", "whatweb"],
        "layout": "workspaces/web.sh",
    },
    "network": {
        "desc": "Network pentesting — nmap, wireshark, responder, crackmapexec",
        "tools": ["nmap", "wireshark", "responder", "crackmapexec", "netdiscover"],
        "layout": "workspaces/network.sh",
    },
    "red-team": {
        "desc": "Red team ops — C2, pivoting, lateral movement",
        "tools": ["metasploit", "havoc", "chisel", "ligolo-ng", "evil-winrm"],
        "layout": "workspaces/red-team.sh",
    },
    "osint": {
        "desc": "OSINT & recon — theHarvester, maltego, shodan, recon-ng",
        "tools": ["theHarvester", "maltego", "recon-ng", "sherlock", "holehe"],
        "layout": "workspaces/osint.sh",
    },
    "forensics": {
        "desc": "Digital forensics & malware analysis — volatility, autopsy, ghidra",
        "tools": ["volatility3", "autopsy", "ghidra", "binwalk", "foremost"],
        "layout": "workspaces/forensics.sh",
    },
}


def launch_workspace(name: str):
    ws = WORKSPACES.get(name)
    if ws is None:
        print(f"\033[31m[!] Unknown workspace '{name}'.\033[0m")
        list_workspaces()
        sys.exit(1)

    print(f"\033[32m[*] Launching workspace: {name}\033[0m")
    print(f"\033[90m    {ws['desc']}\033[0m\n")

    script = os.path.join(os.path.dirname(__file__), "..", "..", ws["layout"])
    if os.path.exists(script):
        subprocess.run(["bash", script])
    else:
        print(f"\033[33m[~] Layout script not found. Dropping into shell.\033[0m")
        print(f"\033[90m    Suggested tools: {', '.join(ws['tools'])}\033[0m")


def list_workspaces():
    print("\033[32m[*] Available workspaces:\033[0m\n")
    for name, info in WORKSPACES.items():
        print(f"  \033[1m{name:<12}\033[0m {info['desc']}")
    print()
