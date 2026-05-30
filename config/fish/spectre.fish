# Spectre fish shell config

set -x SPECTRE_HOME "$HOME/.spectre"
set -x PATH "$HOME/.local/bin" $PATH

# Custom prompt
function fish_prompt
    set_color --bold 00ff9f
    echo -n "spectre"
    set_color normal
    echo -n " "
    set_color cyan
    echo -n (prompt_pwd)
    set_color normal
    echo -n " » "
end

# Aliases
alias ll="ls -lah --color=auto"
alias ports="ss -tulnp"
alias myip="curl -s ifconfig.me && echo"
alias localip="ip route get 1 | awk '{print \$7}' | head -1"

# Spectre quick launchers
alias ws-web="spc workspace web"
alias ws-net="spc workspace network"
alias ws-rt="spc workspace red-team"
alias ws-osint="spc workspace osint"

# Greeting
if status is-interactive
    spc banner 2>/dev/null; or true
end
