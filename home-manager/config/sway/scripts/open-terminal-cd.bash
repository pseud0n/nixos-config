#! /usr/bin/env bash
command=$1
pid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).pid')

#echo "$(ps -ef | grep fish)" > ~/log

process_match=$(ps -ef | grep fish | awk '$3 == pid { print $2 }' pid=$pid)

if [ -z $process_match ]
then
	echo "$command ~"
else
	echo "$command $(pwdx $process_match | awk '{ print $2 }')"
fi
