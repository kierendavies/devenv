set -U tide_left_prompt_items context shlvl pwd git
set -U tide_right_prompt_items status cmd_duration jobs node virtual_env rustc php chruby go kubectl vi_mode
_tide_remove_unusable_items

# Show current time: No
set -U tide_time_format ''

# Prompt Height: One line
set -U tide_left_prompt_frame_enabled false
set -U tide_right_prompt_frame_enabled false

# The rest copied from ~/.config/tide/functions/tide/configure/configs/rainbow.fish
set -U tide_character_bg_color normal
set -U tide_character_color $_tide_color_green
set -U tide_character_color_failure FF0000
set -U tide_character_icon '❯'
set -U tide_character_vi_icon_default '❮'
set -U tide_character_vi_icon_replace '▶'
set -U tide_character_vi_icon_visual V
set -U tide_chruby_bg_color B31209
set -U tide_chruby_color 000000
set -U tide_chruby_icon ''
set -U tide_cmd_duration_bg_color C4A000
set -U tide_cmd_duration_color 000000
set -U tide_cmd_duration_decimals 0
set -U tide_cmd_duration_icon
set -U tide_cmd_duration_threshold 3000
set -U tide_context_always_display false
set -U tide_context_bg_color 444444
set -U tide_context_color_default D7AF87
set -U tide_context_color_root $_tide_color_gold
set -U tide_context_color_ssh D7AF87
set -U tide_git_bg_color 4E9A06
set -U tide_git_bg_color_unstable C4A000
set -U tide_git_bg_color_urgent CC0000
set -U tide_git_color_branch 000000
set -U tide_git_color_conflicted 000000
set -U tide_git_color_dirty 000000
set -U tide_git_color_operation 000000
set -U tide_git_color_staged 000000
set -U tide_git_color_stash 000000
set -U tide_git_color_untracked 000000
set -U tide_git_color_upstream 000000
set -U tide_git_icon
set -U tide_go_bg_color 00ACD7
set -U tide_go_color 000000
set -U tide_go_icon 
set -U tide_jobs_bg_color 444444
set -U tide_jobs_color 4E9A06
set -U tide_jobs_icon ''
set -U tide_kubectl_bg_color 326CE5
set -U tide_kubectl_color 000000
set -U tide_kubectl_icon '⎈'
set -U tide_left_prompt_prefix ''
set -U tide_left_prompt_separator_diff_color ''
set -U tide_left_prompt_separator_same_color ''
set -U tide_left_prompt_suffix ''
set -U tide_node_bg_color 44883E
set -U tide_node_color 000000
set -U tide_node_icon '⬢'
set -U tide_os_bg_color CED7CF
set -U tide_os_color 080808
set -U tide_php_bg_color 617CBE
set -U tide_php_color 000000
set -U tide_php_icon ''
set -U tide_prompt_add_newline_before true
set -U tide_prompt_color_frame_and_connection 6C6C6C
set -U tide_prompt_color_separator_same_color 949494
set -U tide_prompt_icon_connection ' '
set -U tide_prompt_min_cols 26
set -U tide_prompt_pad_items true
set -U tide_pwd_bg_color 3465A4
set -U tide_pwd_color_anchors E4E4E4
set -U tide_pwd_color_dirs E4E4E4
set -U tide_pwd_color_truncated_dirs BCBCBC
set -U tide_pwd_icon
set -U tide_pwd_icon_home
set -U tide_pwd_icon_unwritable ''
set -U tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json
set -U tide_right_prompt_prefix ''
set -U tide_right_prompt_separator_diff_color ''
set -U tide_right_prompt_separator_same_color ''
set -U tide_right_prompt_suffix ''
set -U tide_rustc_bg_color F74C00
set -U tide_rustc_color 000000
set -U tide_rustc_icon ''
set -U tide_shlvl_bg_color 808000
set -U tide_shlvl_color 000000
set -U tide_shlvl_icon ''
set -U tide_shlvl_threshold 1
set -U tide_status_bg_color 2E3436
set -U tide_status_bg_color_failure CC0000
set -U tide_status_color 4E9A06
set -U tide_status_color_failure FFFF00
set -U tide_status_icon '✔'
set -U tide_status_icon_failure '✘'
set -U tide_time_bg_color D3D7CF
set -U tide_time_color 000000
set -U tide_vi_mode_bg_color_default 008000
set -U tide_vi_mode_bg_color_replace 808000
set -U tide_vi_mode_bg_color_visual 000080
set -U tide_vi_mode_color_default 000000
set -U tide_vi_mode_color_replace 000000
set -U tide_vi_mode_color_visual 000000
set -U tide_vi_mode_icon_default DEFAULT
set -U tide_vi_mode_icon_replace REPLACE
set -U tide_vi_mode_icon_visual VISUAL
set -U tide_virtual_env_bg_color 444444
set -U tide_virtual_env_color 00AFAF
set -U tide_virtual_env_icon ''
