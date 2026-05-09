if type -q tide
    if test -z "$(set -n | grep '^tide_')"
        tide configure \
            --auto \
            --style=Rainbow \
            --prompt_colors='True color' \
            --show_time=No \
            --rainbow_prompt_separators=Angled \
            --powerline_prompt_heads=Sharp \
            --powerline_prompt_tails=Flat \
            --powerline_prompt_style='One line' \
            --prompt_spacing=Sparse \
            --icons='Few icons' \
            --transient=Yes
    end

    set -g tide_left_prompt_items context shlvl pwd git
    set -g tide_right_prompt_items status cmd_duration jobs
    set -g tide_status_icon '\uf00c'
    set -g tide_status_icon_failure '\uf00d'
end
