function load_env
    for line in (cat $argv | grep -v '^#')
        if string match -qr '^\w*(#|$)' "$line"
            continue
        end

        set item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
        echo $item[1]
    end
end