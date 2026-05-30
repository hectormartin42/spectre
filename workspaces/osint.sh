#!/usr/bin/env bash
# Spectre — OSINT Workspace

SESSION="spectre-osint"

tmux new-session -d -s "$SESSION" -x 220 -y 50
tmux rename-window -t "$SESSION:0" "osint"

tmux send-keys -t "$SESSION:0" "echo -e '\033[32m[Spectre OSINT Workspace]\033[0m  theHarvester / sherlock / recon-ng'" Enter

tmux split-window -h -t "$SESSION:0"
tmux send-keys -t "$SESSION:0.1" "echo 'theHarvester -d TARGET -b all'" Enter

tmux split-window -v -t "$SESSION:0.0"
tmux send-keys -t "$SESSION:0.2" "spc note list --engagement osint" Enter

tmux select-pane -t "$SESSION:0.0"
tmux attach-session -t "$SESSION"
