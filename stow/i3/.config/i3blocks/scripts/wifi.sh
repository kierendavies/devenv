#!/usr/bin/env bash

if [[ ! -d "/sys/class/net/${interface}/wireless" ]]; then
    exit 1
fi

case "$(cat "/sys/class/net/$interface/operstate")" in
up)
    icon=直
    ssid=$(iw dev "$interface" link | sed -nr 's/^\s*SSID: (.*)$/\1/p')
    # Remove the space before dBm
    signal=$(iw dev "$interface" link | sed -nr 's/^\s*signal: (.*) dBm$/\1/p')dBm

    if [[ $quality -ge -55 ]]; then
        colour="#00FF00"
    elif [[ $quality -ge -70 ]]; then
        colour="#FFF600"
    elif [[ $quality -ge -85 ]]; then
        colour="#FFAE00"
    else
        colour="#FF0000"
    fi
    ;;
down)
    icon=睊
    colour="#A0A0A0"
    ;;
*)
    exit 1
    ;;
esac

echo $icon $ssid $signal
echo $icon
echo $colour