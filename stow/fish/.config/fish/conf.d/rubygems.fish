if type -q ruby
    set -gx GEM_HOME (ruby -e "puts Gem.user_dir")
    set -gx BUNDLE_PATH $GEM_HOME
    fish_add_path -g "$GEM_HOME/bin"
end
