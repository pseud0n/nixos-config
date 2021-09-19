#event=$(sudo libinput list-devices | grep -iE "ELECOM TrackBall Mouse DEFT Pro TrackBall\$" -m 1 -A 1 | tail -1 | awk '{print $2}')
intercept -g /dev/input/event10 | keybinds/build/caps2esc | uinput -d /dev/input/event10
