if type -q ruby
    fish_add_path -g (ruby -e "puts Gem.user_dir")/bin
end
