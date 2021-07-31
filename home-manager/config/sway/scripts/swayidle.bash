#! /usr/bin/env bash
swayidle -w \
	timeout 30 /etc/nixos/home-manager/config/sway/scripts/swaylock.bash \
         timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
         before-sleep 'swaylock -f -c 000000'
