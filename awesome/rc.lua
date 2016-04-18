local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}
-- {{{ Variable definitions
beautiful.init("/usr/share/awesome/themes/default/theme.lua")

terminal = "xterm"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier
}

tag_names = {
    'a', 'z', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    'q', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm',
    'w', 'x', 'c', 'v', 'b', 'n'
}
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag(tag_names, s, layouts[1])
end
-- }}}
-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytasklist = {}
mytasklist.buttons = awful.button({ }, 1, function (c) client.focus = c; c:raise() end)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}
-- {{{ Bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,         }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,         }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,         }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift" }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Standard program
    awful.key({ modkey }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey }, "&",      function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey, "Shift"   }, "<",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "<",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end)
)

for i = 1, 26 do
    tag = tag_names[i]
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey           }, tag, function() awful.tag.viewonly(awful.tag.gettags(mouse.screen)[i]) end),
        awful.key({modkey, "Control"}, tag, function() awful.tag.viewtoggle(awful.tag.gettags(mouse.screen)[i]) end),
        awful.key({modkey, "Shift"  }, tag, function() awful.client.movetotag(awful.tag.gettags(mouse.screen)[i]) end)
    )
end

root.keys(globalkeys)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "Escape", function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "*",      awful.client.movetoscreen                        )
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))
-- }}}
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {rule = {},                   properties = {border_width = 0, raise = true, keys = clientkeys, buttons = clientbuttons}},
    {rule = {class = "MPlayer"},  properties = {floating = true}},
    {rule = {class = "pinentry"}, properties = {floating = true}},
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- {rule = {class = "Firefox"}, properties = {tag = tags[1][2]}},
}

client.connect_signal("manage", function (c, startup) awful.client.setslave(c); client.focus = c end)
-- }}}
