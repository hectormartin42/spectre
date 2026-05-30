import subprocess
import sys
from datetime import datetime


PROFILES = {
    "stealth": ["-sS", "-T2", "-f", "--data-length", "24"],
    "normal":  ["-sV", "-sC", "-T3"],
    "aggressive": ["-sV", "-sC", "-T4", "-A", "--script=vuln"],
    "quick":   ["-sV", "-T4", "--open"],
}


def run_scan(target: str, profile: str, output: str | None, ports: str | None):
    flags = PROFILES.get(profile)
    if flags is None:
        print(f"\033[31m[!] Unknown profile '{profile}'. Available: {', '.join(PROFILES)}\033[0m")
        sys.exit(1)

    cmd = ["nmap"] + flags
    if ports:
        cmd += ["-p", ports]

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_file = output or f"spectre_scan_{target.replace('/', '_')}_{timestamp}"
    cmd += ["-oN", f"{out_file}.txt", "-oX", f"{out_file}.xml", target]

    print(f"\033[32m[*] Scanning {target} with profile '{profile}'\033[0m")
    print(f"\033[90m[*] Output → {out_file}.txt\033[0m\n")

    try:
        subprocess.run(cmd, check=True)
    except FileNotFoundError:
        print("\033[31m[!] nmap not found. Install it first.\033[0m")
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"\033[31m[!] Scan failed: {e}\033[0m")
        sys.exit(1)
