#!/bin/sh

layout fr
xset r rate 200 30
xcape -t 200
xbindkeys -f "$XDG_CONFIG_HOME/xbindkeys"
xrdb ~/config/Xresources
feh -z --bg-max --no-fehbg ~/Pictures/
wmname LG3D
exec awesome
