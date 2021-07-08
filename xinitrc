#!/bin/sh
set -euo pipefail

xset r rate 250 32
layout fr
xbindkeys -f "$XDG_CONFIG_HOME/xbindkeys"
xrdb ~/config/Xresources
feh -z --bg-max --no-fehbg ~/Pictures/
wmname LG3D

exec awesome
