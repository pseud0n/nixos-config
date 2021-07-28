#! /usr/bin/env bash

pid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).pid')

process_match=$(ps -ef | awk '$3 == pid { print $2 }' pid=$pid)

if [ -z $process_match ]
then
	echo "alacritty"
else
	echo "alacritty -e fish -C $(pwdx $process_match | awk '{ print $2 }')"
fi
