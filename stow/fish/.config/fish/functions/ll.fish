# Default omits -A
function ll --wraps=ls
    ls -lAh $argv
end
