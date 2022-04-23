# Only set tide variables if none are already set.
if test -z "$(set -n | grep '^tide_')"
    set -g tide_left_prompt_items context shlvl pwd git
    set -g tide_right_prompt_items status cmd_duration jobs node virtual_env rustc php chruby go kubectl vi_mode
    _tide_remove_unusable_items

    # Show current time: No
    set -g tide_time_format ''

    # Prompt Height: One line
    set -g tide_left_prompt_frame_enabled false
    set -g tide_right_prompt_frame_enabled false

    # The rest copied from ~/.config/tide/functions/tide/configure/configs/rainbow.fish
    set -g tide_character_bg_color normal
    set -g tide_character_color 5FD700
    set -g tide_character_color_failure FF0000
    set -g tide_character_icon '❯'
    set -g tide_character_vi_icon_default '❮'
    set -g tide_character_vi_icon_replace '▶'
    set -g tide_character_vi_icon_visual V
    set -g tide_chruby_bg_color B31209
    set -g tide_chruby_color 000000
    set -g tide_chruby_icon ''
    set -g tide_cmd_duration_bg_color C4A000
    set -g tide_cmd_duration_color 000000
    set -g tide_cmd_duration_decimals 0
    set -g tide_cmd_duration_icon
    set -g tide_cmd_duration_threshold 3000
    set -g tide_context_always_display false
    set -g tide_context_bg_color 444444
    set -g tide_context_color_default D7AF87
    set -g tide_context_color_root D7AF00
    set -g tide_context_color_ssh D7AF87
    set -g tide_git_bg_color 4E9A06
    set -g tide_git_bg_color_unstable C4A000
    set -g tide_git_bg_color_urgent CC0000
    set -g tide_git_color_branch 000000
    set -g tide_git_color_conflicted 000000
    set -g tide_git_color_dirty 000000
    set -g tide_git_color_operation 000000
    set -g tide_git_color_staged 000000
    set -g tide_git_color_stash 000000
    set -g tide_git_color_untracked 000000
    set -g tide_git_color_upstream 000000
    set -g tide_git_icon
    set -g tide_go_bg_color 00ACD7
    set -g tide_go_color 000000
    set -g tide_go_icon 
    set -g tide_jobs_bg_color 444444
    set -g tide_jobs_color 4E9A06
    set -g tide_jobs_icon ''
    set -g tide_kubectl_bg_color 326CE5
    set -g tide_kubectl_color 000000
    set -g tide_kubectl_icon '⎈'
    set -g tide_left_prompt_prefix ''
    set -g tide_left_prompt_separator_diff_color ''
    set -g tide_left_prompt_separator_same_color ''
    set -g tide_left_prompt_suffix ''
    set -g tide_node_bg_color 44883E
    set -g tide_node_color 000000
    set -g tide_node_icon '⬢'
    set -g tide_os_bg_color CED7CF
    set -g tide_os_color 080808
    set -g tide_php_bg_color 617CBE
    set -g tide_php_color 000000
    set -g tide_php_icon ''
    set -g tide_prompt_add_newline_before true
    set -g tide_prompt_color_frame_and_connection 6C6C6C
    set -g tide_prompt_color_separator_same_color 949494
    set -g tide_prompt_icon_connection ' '
    set -g tide_prompt_min_cols 26
    set -g tide_prompt_pad_items true
    set -g tide_pwd_bg_color 3465A4
    set -g tide_pwd_color_anchors E4E4E4
    set -g tide_pwd_color_dirs E4E4E4
    set -g tide_pwd_color_truncated_dirs BCBCBC
    set -g tide_pwd_icon
    set -g tide_pwd_icon_home
    set -g tide_pwd_icon_unwritable ''
    set -g tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json
    set -g tide_right_prompt_prefix ''
    set -g tide_right_prompt_separator_diff_color ''
    set -g tide_right_prompt_separator_same_color ''
    set -g tide_right_prompt_suffix ''
    set -g tide_rustc_bg_color F74C00
    set -g tide_rustc_color 000000
    set -g tide_rustc_icon ''
    set -g tide_shlvl_bg_color 808000
    set -g tide_shlvl_color 000000
    set -g tide_shlvl_icon ''
    set -g tide_shlvl_threshold 1
    set -g tide_status_bg_color 2E3436
    set -g tide_status_bg_color_failure CC0000
    set -g tide_status_color 4E9A06
    set -g tide_status_color_failure FFFF00
    set -g tide_status_icon '✔'
    set -g tide_status_icon_failure '✘'
    set -g tide_time_bg_color D3D7CF
    set -g tide_time_color 000000
    set -g tide_vi_mode_bg_color_default 008000
    set -g tide_vi_mode_bg_color_replace 808000
    set -g tide_vi_mode_bg_color_visual 000080
    set -g tide_vi_mode_color_default 000000
    set -g tide_vi_mode_color_replace 000000
    set -g tide_vi_mode_color_visual 000000
    set -g tide_vi_mode_icon_default DEFAULT
    set -g tide_vi_mode_icon_replace REPLACE
    set -g tide_vi_mode_icon_visual VISUAL
    set -g tide_virtual_env_bg_color 444444
    set -g tide_virtual_env_color 00AFAF
    set -g tide_virtual_env_icon ''
end
