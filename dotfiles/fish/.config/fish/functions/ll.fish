function ll --wraps ls --description "List contents of directory using long format"
    grc.wrap ls -lah $argv
end
