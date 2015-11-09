#!/bin/sh

# Mouse settings
xmodmap -e "pointer = 1 2 3 4 5 0 0 4 5 0 0 0 0 0 0 0 0 0"
#xset m 5/2 5

# Keyboard settings
xset r rate 200 42
setxkbmap fr -variant oss_nodeadkeys

# Fix right control
xmodmap -e 'keycode 105 = Control_R' -e 'add Control = Control_R'

# Map Caps Lock to Control, or escape when pressed alone
xmodmap -e 'clear Lock' -e 'keycode 66 = Control_L' -e 'add Control = Control_L'
~/bin/xcape -t 200

# Bind keys
xbindkeys -f "$XDG_DATA_HOME/xbindkeys"

# Load settings
husl | xrdb

# Trick Java Swing into working
which wmname && wmname LG3D

# Set background
feh -z --bg-max --no-fehbg ~/Pictures/

exec xterm
