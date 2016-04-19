awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Variable definitions
super = {"Mod4"}
shift = {"Mod4", "Shift"}
prompt = awful.widget.prompt()
layouts = {awful.layout.suit.max.fullscreen, awful.layout.suit.tile}
tags = {
    'a', 'z', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    'q', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm',
    'w', 'x', 'c', 'v', 'b', 'n'
}

for s = 1, screen.count() do
    awful.tag(tags, s, layouts[1])
end

function tab_focus(i)
    awful.client.focus.byidx(i)
    if client.focus then client.focus:raise() end
end

-- Bindings
globalkeys = awful.util.table.join(
    awful.key(super, "Left",   awful.tag.viewprev),
    awful.key(super, "Right",  awful.tag.viewnext),
    awful.key(super, "Tab",    function() tab_focus( 1) end),
    awful.key(shift, "Tab",    function() tab_focus(-1) end),
    awful.key(super, "Return", function() awful.util.spawn('xterm') end),
    awful.key(super, "&",      function() prompt:run() end),
    awful.key(shift, "<",      function() awful.tag.incmwfact( 0.05) end),
    awful.key(super, "<",      function() awful.tag.incmwfact(-0.05) end),
    awful.key(super, "space",  function() awful.layout.inc(layouts,  1) end),
    awful.key(shift, "space",  function() awful.layout.inc(layouts, -1) end))

for i = 1, 26 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key(super, tags[i], function() awful.tag.viewonly(awful.tag.gettags(mouse.screen)[i]) end),
        awful.key(shift, tags[i], function() awful.client.movetotag(awful.tag.gettags(mouse.screen)[i]) end))
end

awful.rules.rules = {{rule = {}, properties = {
    border_width = 1,
    raise = true,
    keys = awful.util.table.join(
        awful.key(shift, "Escape", function(c) c:kill() end),
        awful.key(super, "*",      awful.client.movetoscreen)),
    buttons = awful.util.table.join(
        awful.button({},    1, function(c) client.focus = c end),
        awful.button(super, 1, awful.mouse.client.move),
        awful.button(super, 2, awful.client.floating.toggle),
        awful.button(super, 3, awful.mouse.client.resize)),
}}}

root.keys(globalkeys)
client.connect_signal("manage", function(c) awful.client.setslave(c); client.focus = c end)
