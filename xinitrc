#!/bin/sh

setxkbmap fr -variant oss_nodeadkeys
xset r rate 200 30
xmodmap -e 'clear Lock' -e 'keycode 66  = Control_L' -e 'add Control = Control_L'
xmodmap -e 'clear mod3' -e 'keycode 105 = Control_R' -e 'add Control = Control_R'
xmodmap -e 'keycode 61 = exclam backslash exclam backslash exclamdown U203D'
xcape -t 200
xbindkeys -f "$XDG_CONFIG_HOME/xbindkeys"
xautolock -time 5 -locker slock &
xrdb ~/config/Xresources
feh -z --bg-max --no-fehbg ~/Pictures/
wmname LG3D
exec awesome
