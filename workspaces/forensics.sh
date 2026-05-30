#!/usr/bin/env bash
# Spectre — Forensics Workspace

SESSION="spectre-forensics"

tmux new-session -d -s "$SESSION" -x 220 -y 50
tmux rename-window -t "$SESSION:0" "forensics"

tmux send-keys -t "$SESSION:0" "echo -e '\033[32m[Spectre Forensics Workspace]\033[0m  volatility3 / binwalk / ghidra'" Enter

tmux split-window -h -t "$SESSION:0"
tmux send-keys -t "$SESSION:0.1" "echo 'vol -f memory.dmp windows.pslist'" Enter

tmux select-pane -t "$SESSION:0.0"
tmux attach-session -t "$SESSION"
