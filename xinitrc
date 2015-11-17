#!/bin/sh

setxkbmap fr -variant oss_nodeadkeys
xset r rate 200 30
xmodmap -e 'clear Lock' -e 'keycode 66  = Control_L' -e 'add Control = Control_L'
xmodmap -e 'clear mod3' -e 'keycode 105 = Control_R' -e 'add Control = Control_R'
xmodmap -e 'pointer = 1 2 3 4 5 0 0 6 7 0 0 10 0 0 0 0 0 0'
xcape -t 200
xbindkeys -f "$XDG_DATA_HOME/xbindkeys"
xautolock -time 5 -locker slock &
wmname LG3D
husl | xrdb
feh -z --bg-max --no-fehbg ~/Pictures/
which awesome && exec awesome
exec xterm
