awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

super = {"Mod4"}
shift = {"Mod4", "Shift"}
layouts = {awful.layout.suit.max.fullscreen, awful.layout.suit.tile}
tags = {
    'a', 'z', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    'q', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm',
    'w', 'x', 'c', 'v', 'b', 'n'
}
for s = 1, screen.count() do awful.tag(tags, s, layouts[1]) end

root.keys(awful.util.table.join(
    awful.key(super, "Left",   awful.tag.viewprev),
    awful.key(super, "Right",  awful.tag.viewnext),
    awful.key(super, "*",      awful.client.movetoscreen),
    awful.key(super, ":",      awful.client.floating.toggle),
    awful.key(shift, "Escape", function() client.focus:kill() end),
    awful.key(super, "Tab",    function() awful.client.focus.byidx( 1); client.focus:raise() end),
    awful.key(shift, "Tab",    function() awful.client.focus.byidx(-1); client.focus:raise() end),
    awful.key(super, "Return", function() awful.util.spawn('xterm') end),
    awful.key(super, "&",      function() awful.widget.prompt():run() end),
    awful.key(super, "space",  function() awful.layout.inc(layouts, 1) end)))

for i = 1, 26 do
    root.keys(awful.util.table.join(root.keys(),
        awful.key(super, tags[i], function() awful.tag.viewonly(awful.tag.gettags(mouse.screen)[i]) end),
        awful.key(shift, tags[i], function() awful.client.movetotag(awful.tag.gettags(mouse.screen)[i]) end)))
end

awful.rules.rules = {{rule = {}, properties = {
    border_width = 1,
    raise = true,
    buttons = awful.util.table.join(
        awful.button({},    1, function(c) client.focus = c end),
        awful.button(super, 1, awful.mouse.client.move),
        awful.button(super, 3, awful.mouse.client.resize)),
}}}

client.connect_signal("manage", function(c) awful.client.setslave(c); client.focus = c end)
