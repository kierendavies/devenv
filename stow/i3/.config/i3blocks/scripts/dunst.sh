#!/usr/bin/env bash

if [[ -n "$BLOCK_BUTTON" ]]; then
    dunstctl set-paused toggle
fi

case $(dunstctl is-paused) in
false)
    icon=
    colour="#FFFFFF"
    ;;
true)
    icon=
    colour="#FF0000"
    ;;
*)
    exit 1
    ;;
esac

echo $icon
echo $icon
echo $colour
