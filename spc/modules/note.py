import os
import json
from datetime import datetime
from pathlib import Path

NOTES_DIR = Path.home() / ".spectre" / "notes"


def _ensure_dir():
    NOTES_DIR.mkdir(parents=True, exist_ok=True)


def add_note(text: str, tag: str | None, engagement: str | None, file: str | None):
    _ensure_dir()
    note = {
        "timestamp": datetime.now().isoformat(),
        "engagement": engagement or "general",
        "tag": tag,
        "text": text,
        "file": file,
    }
    note_file = NOTES_DIR / f"{note['engagement']}.jsonl"
    with open(note_file, "a") as f:
        f.write(json.dumps(note) + "\n")
    print(f"\033[32m[+] Note saved\033[0m  [{note['engagement']}]  {tag or ''}")
    if file:
        print(f"\033[90m    Attached: {file}\033[0m")


def list_notes(engagement: str | None):
    _ensure_dir()
    target = engagement or "general"
    note_file = NOTES_DIR / f"{target}.jsonl"
    if not note_file.exists():
        print(f"\033[33m[~] No notes for engagement '{target}'\033[0m")
        return
    print(f"\033[32m[*] Notes — {target}\033[0m\n")
    with open(note_file) as f:
        for line in f:
            n = json.loads(line)
            tag_str = f"  \033[33m[{n['tag']}]\033[0m" if n["tag"] else ""
            print(f"  \033[90m{n['timestamp'][:19]}\033[0m{tag_str}  {n['text']}")
    print()
