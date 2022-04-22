# Enable colour
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
if command -q lsd
    alias ls lsd
    alias tree 'lsd --tree'
end

# Shortcuts
alias ll 'ls -lAh' # Default doesn't do -A
command -q nvim; and alias vim nvim
