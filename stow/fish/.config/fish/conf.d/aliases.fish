# Enable colour
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
if type -q lsd
    alias ls lsd
    alias tree 'lsd --tree'
end

# Shortcuts
alias ll 'ls -lAh' # Default doesn't do -A
type -q nvim; and alias vim nvim
