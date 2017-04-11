require("awful.autofocus")
aw = require("awful")
rules = require("awful.rules")

super = {"Mod4"}
shift = {"Mod4", "Shift"}
layouts = {aw.layout.suit.tile, aw.layout.suit.magnifier, aw.layout.suit.floating}
tags = {
    'a', 'z', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    'q', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm',
    'w', 'x', 'c', 'v', 'b', 'n'
}

function tag(i) return aw.tag.gettags(mouse.screen)[i] end
for s = 1, screen.count() do aw.tag(tags, s, layouts[1]) end

root.keys(aw.util.table.join(
    aw.key(super, "Left",      aw.tag.viewprev),
    aw.key(super, "Right",     aw.tag.viewnext),
    aw.key(super, "*",         aw.client.movetoscreen),
    aw.key(shift, "BackSpace", awesome.restart),
    aw.key(super, "Escape",    function() client.focus:kill() end),
    aw.key(super, "Tab",       function() aw.client.focus.byidx( 1) end),
    aw.key(shift, "Tab",       function() aw.client.focus.byidx(-1) end),
    aw.key(super, "Return",    function() aw.util.spawn('vvvvvt') end),
    aw.key(super, "&",         function() aw.widget.prompt():run() end),
    aw.key(shift, "<",         function() aw.tag.incmwfact( 0.05) end),
    aw.key(super, "<",         function() aw.tag.incmwfact(-0.05) end),
    aw.key(super, "space",     function() aw.layout.inc(layouts, 1) end)))

for i = 1, #tags do
    root.keys(aw.util.table.join(root.keys(),
        aw.key(super, tags[i], function() aw.tag.viewonly(tag(i)) end),
        aw.key(shift, tags[i], function() aw.client.movetotag(tag(i)) end)))
end

rules.rules = {{rule = {}, callback = aw.client.setslave, properties = {
    border_width = 0,
    focus = true,
    buttons = aw.util.table.join(
        aw.button({}, 1, function(c) client.focus = c end),
        aw.button(super, 1, aw.mouse.client.move),
        aw.button(super, 3, aw.mouse.client.resize))
}}}
client.connect_signal("focus", function(c) c:raise() end)
