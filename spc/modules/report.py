import json
import os
from datetime import datetime
from pathlib import Path

NOTES_DIR = Path.home() / ".spectre" / "notes"
REPORTS_DIR = Path.home() / ".spectre" / "reports"


def generate_report(engagement: str, fmt: str, output: str | None):
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    note_file = NOTES_DIR / f"{engagement}.jsonl"

    if not note_file.exists():
        print(f"\033[31m[!] No notes found for engagement '{engagement}'\033[0m")
        return

    notes = []
    with open(note_file) as f:
        for line in f:
            notes.append(json.loads(line))

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_name = output or f"{engagement}_{timestamp}"

    if fmt == "md":
        _write_markdown(notes, engagement, out_name)
    elif fmt == "txt":
        _write_text(notes, engagement, out_name)
    else:
        print(f"\033[31m[!] Format '{fmt}' not supported yet. Use: md, txt\033[0m")


def _write_markdown(notes: list, engagement: str, out_name: str):
    path = REPORTS_DIR / f"{out_name}.md"
    with open(path, "w") as f:
        f.write(f"# Spectre Report — {engagement}\n\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n---\n\n")
        by_tag: dict = {}
        for n in notes:
            tag = n.get("tag") or "general"
            by_tag.setdefault(tag, []).append(n)
        for tag, items in by_tag.items():
            f.write(f"## {tag.upper()}\n\n")
            for item in items:
                f.write(f"- `{item['timestamp'][:19]}` {item['text']}\n")
                if item.get("file"):
                    f.write(f"  - File: `{item['file']}`\n")
            f.write("\n")
    print(f"\033[32m[+] Report saved → {path}\033[0m")


def _write_text(notes: list, engagement: str, out_name: str):
    path = REPORTS_DIR / f"{out_name}.txt"
    with open(path, "w") as f:
        f.write(f"SPECTRE REPORT — {engagement.upper()}\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}\n")
        f.write("=" * 60 + "\n\n")
        for n in notes:
            tag = f"[{n['tag']}] " if n.get("tag") else ""
            f.write(f"{n['timestamp'][:19]}  {tag}{n['text']}\n")
    print(f"\033[32m[+] Report saved → {path}\033[0m")
