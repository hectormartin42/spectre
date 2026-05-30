#!/usr/bin/env bash
# Spectre — Network Pentesting Workspace

SESSION="spectre-network"

tmux new-session -d -s "$SESSION" -x 220 -y 50
tmux rename-window -t "$SESSION:0" "network"

tmux send-keys -t "$SESSION:0" "echo -e '\033[32m[Spectre Network Workspace]\033[0m  nmap / responder / crackmapexec'" Enter

tmux split-window -h -t "$SESSION:0"
tmux send-keys -t "$SESSION:0.1" "echo 'spc scan -t 192.168.1.0/24 --profile stealth'" Enter

tmux split-window -v -t "$SESSION:0.0"
tmux send-keys -t "$SESSION:0.2" "ip a" Enter

tmux select-pane -t "$SESSION:0.0"
tmux attach-session -t "$SESSION"
