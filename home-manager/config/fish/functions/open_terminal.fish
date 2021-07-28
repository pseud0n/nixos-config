function open_terminal
	set process_match (ps -ef | awk '$3 == pid { print $2 }' pid=(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).pid')) | awk '{ print $2 }'
    if test -z $process_match
        swaymsg exec alacritty
    else
        swaymsg exec "alacritty -e fish -C"(pwdx process-match)
    end
end
