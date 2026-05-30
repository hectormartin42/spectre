#!/usr/bin/env bash
# Spectre — Red Team Workspace

SESSION="spectre-redteam"

tmux new-session -d -s "$SESSION" -x 220 -y 50
tmux rename-window -t "$SESSION:0" "red-team"

tmux send-keys -t "$SESSION:0" "echo -e '\033[32m[Spectre Red Team Workspace]\033[0m  metasploit / chisel / evil-winrm'" Enter

tmux split-window -h -t "$SESSION:0"
tmux send-keys -t "$SESSION:0.1" "echo 'msfconsole -q'" Enter

tmux split-window -v -t "$SESSION:0.0"
tmux send-keys -t "$SESSION:0.2" "spc note list --engagement redteam" Enter

tmux select-pane -t "$SESSION:0.0"
tmux attach-session -t "$SESSION"
