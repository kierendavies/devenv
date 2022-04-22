# mill expects to be invoked by its full path
function mill --wraps mill
    eval (type -P mill) $argv
end
