set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME "$HOME/.config"

string replace --regex '^' 'set -U ' <"$XDG_CONFIG_HOME/fish/functions/tide/configure/configs/rainbow.fish" | source

_tide_find_and_remove newline fake_tide_left_prompt_items
set fake_tide_left_prompt_frame_enabled false
set fake_tide_right_prompt_frame_enabled false

_tide_remove_unusable_items
