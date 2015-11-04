#!/bin/sh

# Font settings
xset +fp /usr/share/fonts/local
xset fp rehash

# Mouse settings
xmodmap -e "pointer = 1 2 3 4 5 0 0 6 7 0 0 10 0 0 0 0 0 0"
#xset m 5/2 5

# Keyboard settings
setxkbmap fr -variant oss_nodeadkeys
xset r rate 200 30

# Fix right control
xmodmap -e 'keycode 105 = Control_R' -e 'add Control = Control_R'

# Map Caps Lock to Control, or escape when pressed alone
xmodmap -e 'clear Lock' -e 'keycode 66 = Control_L' -e 'add Control = Control_L'
# Yes, twice
~/bin/xcape -t 200
~/bin/xcape -t 200

# Map space to AltGr (or just space when pressed alone, phew)
#xmodmap -e 'keycode 65 = ISO_Level3_Shift' -e 'keycode any = space'
# ~/bin/xcape -t 200 -e 'ISO_Level3_Shift=space'

# Map Shift to backspace when pressed alone
# ~/bin/xcape -t 200 -e 'Shift_L=BackSpace;Shift_R=BackSpace'

# Load settings
xrdb ~/.Xresources

# Window manager
exec awesome
