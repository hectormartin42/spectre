#!/usr/bin/env bash
# Spectre — Web Pentesting Workspace

SESSION="spectre-web"

tmux new-session -d -s "$SESSION" -x 220 -y 50

tmux rename-window -t "$SESSION:0" "web"

# Pane 0: main shell
tmux send-keys -t "$SESSION:0" "echo -e '\033[32m[Spectre Web Workspace]\033[0m  sqlmap / ffuf / nuclei / gobuster'" Enter

# Pane 1: ffuf ready
tmux split-window -h -t "$SESSION:0"
tmux send-keys -t "$SESSION:0.1" "echo 'ffuf -w /usr/share/wordlists/dirb/common.txt -u http://TARGET/FUZZ'" Enter

# Pane 2: notes
tmux split-window -v -t "$SESSION:0.0"
tmux send-keys -t "$SESSION:0.2" "spc note list" Enter

tmux select-pane -t "$SESSION:0.0"
tmux attach-session -t "$SESSION"
