set __fish_mill_opts_requiring_param -c --code -h --home -p --predef --color -D --define -j --jobs --import

set __fish_mill_subcommands all clean inspect par path plan resolve show showNamed shutdown version visualize visualizePlan

# no args
# shutdown
# version

# target*
# clean
# inspect
# plan
# resolve
# show
# showNamed
# visualize
# visualizePlan

# exactly two targets
# path

# deprecated
# all
# par

# function __fish_mill_accept_opt
#     set -l args (commandline -pco)[2..]
#     while count $args
#         set -l arg $args[1]
#         set -e args[1]

#         # If the option takes a parameter, skip it.
#         if contains -- $arg $__fish_mill_opts_requiring_param
#             set -e args[1]
#         else if not string match -- '-*' $arg
#             return 1
#         end
#     end
#     return 0
# end

# function __fish_mill_accept_target
#     set -l args (commandline -pco)[2..]

#     # First argument may be a target.
#     if not count $args
#         return 0
#     end

#     # Plus must be followed by a target
#     if test $args[-1] = "+"
#         return 0
#     end

#     # Some options must be followed by parameters.
#     if contains -- $args[-1] $__fish_mill_opts_requiring_param
#         return 1
#     end

#     # That parameter may be followed by a target.
#     if contains -- "$args[-2]" $__fish_mill_opts_requiring_param
#         return 0
#     end

#     # All other options may be immediately followed by a target.
#     if string match -- '-*' $args[-1]
#         return 0
#     end

#     # Otherwise the last argument was a target, so the next may not be.
#     return 1
# end

# function __fish_mill_accept_plus
#     set -l args (commandline -pco)[2..]

#     if not count $args
#         return 1
#     end

#     if test $args[-1] = "+"
#         return 1
#     end

#     if string match -- '-*' $args[-1]
#         return 1
#     end

#     # This is technically wrong if length of args is less than 2, but it works
#     # because $opts_requiring_params doesn't contain duplicates.
#     if contains -- "$args[-2]" $__fish_mill_opts_requiring_param
#         return 1
#     end

#     return 0
# end

function __fish_mill_args_state
    if not set -q argv
        set -f argv (commandline -pco)
    end
    set -e argv[1]

    set -f state first_opt

    while count $argv >/dev/null
        set -l arg $argv[1]
        set -e argv[1]

        if contains -- "$arg" $__fish_mill_opts_requiring_param
            set -f state opt_param
        else if string match -- '-*' "$arg"
            set -f state opts
            # else if test "$arg" = resolve
            #     set -f state resolve
        else if test "$arg" = "+"
            set -f state target_name
        else if test "$state" = opt_param
            set -f state opts
        else
            set -f state target_params
        end
        # TODO plan, resolve, etc...
    end

    echo $state
end

function __fish_mill_accept_first_opt
    if contains (__fish_mill_args_state) first_opt
        return 0
    end
    return 1
end

function __fish_mill_accept_opt
    if contains (__fish_mill_args_state) first_opt opts
        return 0
    end
    return 1
end

function __fish_mill_accept_target
    if contains (__fish_mill_args_state) first_opt opts target_name
        return 0
    end
    return 1
end

function __fish_mill_accept_plus
    if contains (__fish_mill_args_state) target_params
        return 0
    end
    return 1
end

function __fish_mill_targets
    if test ! -e build.sc
        return 1
    end

    set -l targets
    for target in (mill --disable-ticker resolve __ 2>/dev/null)
        if contains "$target" $__fish_mill_subcommands
            continue
        end

        set -a targets $target

        # set -l components (string split '.' $target)
        # set -l count (count $components)
        # for i in (seq $count)
        #     set -l components_copy $components
        #     set components_copy[$i] _
        #     set -a targets (string join . $components_copy)
        # end
    end

    printf "%s\n" $targets | sort -u
end

function __fish_mill_targets_cached
    if test ! -e build.sc
        return 1
    end

    set -l build_file (realpath build.sc)

    set -l xdg_cache_home $XDG_CACHE_HOME
    if test -z $xdg_cache_home
        set xdg_cache_home $HOME/.cache
    end

    set -l cache_dir $xdg_cache_home/fish/mill_completions
    mkdir -p $cache_dir
    set -l cache_file $cache_dir/(__fish_md5 -s $build_file)

    # Populate the cache if it doesn't exist or if build.sc is updated.
    if test ! -e $cache_file; or test (stat -c %Y $cache_file) -lt (stat -c %Y $build_file)
        __fish_mill_targets >$cache_file
    end

    cat $cache_file
end

# Don't complete with files
complete -c mill -f

# Options only allowed as the first argument
complete -c mill -n __fish_mill_accept_first_opt -l bsp \
    -d "Enable BSP server mode"
complete -c mill -n __fish_mill_accept_first_opt -l no-server \
    -d "Run Mill in interactive mode"
complete -c mill -n __fish_mill_accept_first_opt -l repl \
    -d "Run Mill in interactive mode and start a build REPL"

# Options without parameters
complete -c mill -n __fish_mill_accept_opt -l no-default-predef \
    -d "Disable the default predef"
complete -c mill -n __fish_mill_accept_opt -o s -l silent \
    -d "Make ivy logs go silent instead of printing"
complete -c mill -n __fish_mill_accept_opt -o w -l watch \
    -d "Watch and re-run your scripts when they change"
complete -c mill -n __fish_mill_accept_opt -l thin \
    -d "Hide parts of the core of Ammonite and some of its dependencies"
complete -c mill -n __fish_mill_accept_opt -l help \
    -d "Print help message"
complete -c mill -n __fish_mill_accept_opt -o v -l version \
    -d "Show mill version and exit"
complete -c mill -n __fish_mill_accept_opt -o b -l bell \
    -d "Ring the bell once if the run completes successfully, twice if it fails"
complete -c mill -n __fish_mill_accept_opt -l disable-ticker \
    -d "Disable ticker log (e.g. short-lived prints of stages and progress bars)"
complete -c mill -n __fish_mill_accept_opt -o d -l debug \
    -d "Show debug output on STDOUT"
complete -c mill -n __fish_mill_accept_opt -o k -l keep-going \
    -d "Continue build, even after build failures"

# Options with parameters
complete -c mill -n __fish_mill_accept_opt -o c -l code -x \
    -d "Pass in code to be run immediately in the REPL"
complete -c mill -n __fish_mill_accept_opt -o h -l home -x -a "(__fish_complete_directories (commandline -tc) '')" \
    -d "The home directory of the REPL"
complete -c mill -n __fish_mill_accept_opt -o p -l predef -r \
    -d "Load your predef from a custom location"
complete -c mill -n __fish_mill_accept_opt -l color -x -a "true false" \
    -d "Enable or disable colored output"
complete -c mill -n __fish_mill_accept_opt -o D -l define -x \
    -d "Define (or overwrite) a system property"
complete -c mill -n __fish_mill_accept_opt -o j -l jobs -x -a "0 1" \
    -d "Allow processing N targets in parallel"
complete -c mill -n __fish_mill_accept_opt -l import -x \
    -d "Additional ivy dependencies to load into mill"

# Subcommands
complete -c mill -n __fish_mill_accept_target -a clean \
    -d "Delete the given targets from the out directory"
complete -c mill -n __fish_mill_accept_target -a inspect \
    -d "Display metadata about the given task without actually running it"
complete -c mill -n __fish_mill_accept_target -a path \
    -d "Print some dependency path from the `src` task to the `dest` task"
complete -c mill -n __fish_mill_accept_target -a plan \
    -d "Print the execution plan"
complete -c mill -n __fish_mill_accept_target -a resolve \
    -d "Resolve a mill query string and print out the tasks it resolves to"
complete -c mill -n __fish_mill_accept_target -a show \
    -d "Run a given task and print the JSON result to stdout"
complete -c mill -n __fish_mill_accept_target -a showNamed \
    -d "Run a given task and print the results as a JSON dictionary to stdout"
complete -c mill -n __fish_mill_accept_target -a shutdown \
    -d "Shut down mill's background server"
complete -c mill -n __fish_mill_accept_target -a version \
    -d "Show the mill version"
complete -c mill -n __fish_mill_accept_target -a visualize \
    -d "Render the dependencies between the given tasks as an SVG"
complete -c mill -n __fish_mill_accept_target -a visualizePlan \
    -d "Render the dependencies between the given tasks, and all their dependencies, as an SVG"

# Targets
complete -c mill -n __fish_mill_accept_target -a "(__fish_mill_targets_cached)"

# Plus, for multiple targets. Maybe not that useful to complete.
# complete -c mill -n __fish_mill_accept_plus -a "+"

# Use the same completions for millw
complete -c millw -w mill
