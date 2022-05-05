#!/usr/bin/env bash

if [[ ! -d "/sys/class/net/${interface}/wireless" ]]; then
    exit 1
fi

case "$(cat "/sys/class/net/$interface/operstate")" in
up)
    icon=直
    ssid=$(iw dev "$interface" link | sed -nr 's/^\s*SSID: (.*)$/\1/p')
    signal=$(iw dev "$interface" link | sed -nr 's/^\s*signal: (.*) dBm$/\1/p')

    if [[ $signal -ge -55 ]]; then
        colour="#00FF00"
    elif [[ $signal -ge -70 ]]; then
        colour="#FFF600"
    elif [[ $signal -ge -85 ]]; then
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

echo $icon $ssid ${signal}dBm
echo $icon
echo $colour
