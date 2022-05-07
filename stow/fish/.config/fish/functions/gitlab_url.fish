function gitlab_url -a path
    # Fail early if not in a git repository.
    set -l root_path (git rev-parse --show-toplevel); or return $status

    # These variables will be populated by the loop and the regex match.
    set -l remote
    set -l host
    set -l project
    for remote in (git remote)
        set -l remote_url (git remote get-url $remote)
        if string match -rq '^(https?://|git@)(?<host>[0-9A-Za-z.-]+)[/:](?<project>.*?)(\.git)?$' -- $remote_url
            if string match -q gitlab -- $host
                break
            end
        end
    end
    if test -z "$host"
        echo "error: no GitLab remote found" >&2
        return 1
    end

    set -l url "https://$host/$project"

    if test -n "$path"
        set -l remote_refs (git for-each-ref --format="%(refname)" refs/remotes/$remote)
        if ! count $remote_refs >/dev/null
            echo "error: no refs matching refs/remotes/$remote" >&2
            return 1
        end

        set -l rev (git merge-base HEAD $remote_refs); or return $status

        set -l behind_by (git rev-list --count $rev..HEAD)
        if test "$behind_by" -gt 0
            echo "warning: remote is behind by $behind_by commits" >&2
        end

        set -l rel_path (realpath --no-symlinks --relative-to=$root_path $path)

        if test $rel_path = "."
            set url "$url/-/tree/$rev"
        else
            set -l type (git cat-file -t $rev:$rel_path); or return $status

            set url "$url/-/$type/$rev/$rel_path"
        end
    end

    echo $url
end
