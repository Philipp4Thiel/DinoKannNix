{ config, pkgs, lib, ... }:

{
  # Install packages that match your Hyprland setup but for X11
  home.packages = with pkgs; [
    # Application launcher (similar to wofi)
    rofi
    
    # File manager (same as in Hyprland)
    xfce.thunar
    
    # Notification center equivalent for X11
    dunst
    
    # Bluetooth manager (same as in Hyprland)
    blueman
    
    # Screenshot utilities
    scrot
    maim
    
    # Clipboard management
    xclip
    
    # Authentication
    gnome-keyring
    polkit_gnome
  ];

  # Configure AwesomeWM
  xsession.windowManager.awesome = {
    enable = true;
    
    # Create AwesomeWM configuration
    luaModules = with pkgs.luaPackages; [
      luarocks
      luadbi-mysql
    ];
  };

  # Create the AwesomeWM rc.lua configuration file
  xdg.configFile."awesome/rc.lua" = {
    text = ''
      -- Standard awesome libraries
      local gears = require("gears")
      local awful = require("awful")
      require("awful.autofocus")
      local wibox = require("wibox")
      local beautiful = require("beautiful")
      local naughty = require("naughty")
      local menubar = require("menubar")
      local hotkeys_popup = require("awful.hotkeys_popup")
      require("awful.hotkeys_popup.keys")

      -- {{{ Error handling
      if awesome.startup_errors then
          naughty.notify({ preset = naughty.config.presets.critical,
                           title = "Oops, there were errors during startup!",
                           text = awesome.startup_errors })
      end

      -- Handle runtime errors after startup
      do
          local in_error = false
          awesome.connect_signal("debug::error", function (err)
              if in_error then return end
              in_error = true

              naughty.notify({ preset = naughty.config.presets.critical,
                              title = "Oops, an error happened!",
                              text = tostring(err) })
              in_error = false
          end)
      end
      -- }}}

      -- {{{ Variable definitions
      beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

      -- This is used later as the default terminal and editor to run.
      terminal = "kitty"
      editor = os.getenv("EDITOR") or "nvim"
      editor_cmd = terminal .. " -e " .. editor
      file_manager = "thunar"
      menu_launcher = "rofi -show drun"

      -- Default modkey.
      -- Usually, Mod4 is the key with a logo between Control and Alt.
      modkey = "Mod4"

      -- Table of layouts to cover with awful.layout.inc, order matters.
      awful.layout.layouts = {
          awful.layout.suit.tile,
          awful.layout.suit.tile.left,
          awful.layout.suit.tile.bottom,
          awful.layout.suit.tile.top,
          awful.layout.suit.floating,
          awful.layout.suit.fair,
          awful.layout.suit.fair.horizontal,
          awful.layout.suit.spiral,
          awful.layout.suit.spiral.dwindle,
          awful.layout.suit.max,
          awful.layout.suit.max.fullscreen,
          awful.layout.suit.magnifier,
          awful.layout.suit.corner.nw,
      }
      -- }}}

      -- {{{ Menu
      -- Create a launcher widget and a main menu
      myawesomemenu = {
         { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
         { "manual", terminal .. " -e man awesome" },
         { "edit config", editor_cmd .. " " .. awesome.conffile },
         { "restart", awesome.restart },
         { "quit", function() awesome.quit() end },
      }

      mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

      -- }}}

      -- {{{ Wibar
      -- Create a textclock widget
      mytextclock = wibox.widget.textclock(" %H:%M    %d.%m.%Y ")

      -- Create a wibox for each screen and add it
      local taglist_buttons = gears.table.join(
          awful.button({ }, 1, function(t) t:view_only() end),
          awful.button({ modkey }, 1, function(t)
                                    if client.focus then
                                        client.focus:move_to_tag(t)
                                    end
                                end),
          awful.button({ }, 3, awful.tag.viewtoggle),
          awful.button({ modkey }, 3, function(t)
                                    if client.focus then
                                        client.focus:toggle_tag(t)
                                    end
                                end),
          awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
          awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
      )

      local tasklist_buttons = gears.table.join(
          awful.button({ }, 1, function (c)
                               if c == client.focus then
                                   c.minimized = true
                               else
                                   c:emit_signal(
                                       "request::activate",
                                       "tasklist",
                                       {raise = true}
                                   )
                               end
                           end),
          awful.button({ }, 3, function()
                               awful.menu.client_list({ theme = { width = 250 } })
                           end),
          awful.button({ }, 4, function ()
                               awful.client.focus.byidx(1)
                           end),
          awful.button({ }, 5, function ()
                               awful.client.focus.byidx(-1)
                           end))

      awful.screen.connect_for_each_screen(function(s)
          -- Each screen has its own tag table.
          awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

          -- Create a promptbox for each screen
          s.mypromptbox = awful.widget.prompt()
          
          -- Create an imagebox widget which will contain an icon indicating which layout we're using.
          s.mylayoutbox = awful.widget.layoutbox(s)
          s.mylayoutbox:buttons(gears.table.join(
                                 awful.button({ }, 1, function () awful.layout.inc( 1) end),
                                 awful.button({ }, 3, function () awful.layout.inc(-1) end),
                                 awful.button({ }, 4, function () awful.layout.inc( 1) end),
                                 awful.button({ }, 5, function () awful.layout.inc(-1) end)))
          
          -- Create a taglist widget
          s.mytaglist = awful.widget.taglist {
              screen  = s,
              filter  = awful.widget.taglist.filter.all,
              buttons = taglist_buttons
          }

          -- Create a tasklist widget
          s.mytasklist = awful.widget.tasklist {
              screen  = s,
              filter  = awful.widget.tasklist.filter.currenttags,
              buttons = tasklist_buttons
          }

          -- Create the wibox
          s.mywibox = awful.wibar({ position = "top", screen = s, height = 36 })

          -- Add widgets to the wibox
          s.mywibox:setup {
              layout = wibox.layout.align.horizontal,
              { -- Left widgets
                  layout = wibox.layout.fixed.horizontal,
                  s.mytaglist,
                  s.mypromptbox,
              },
              s.mytasklist, -- Middle widget
              { -- Right widgets
                  layout = wibox.layout.fixed.horizontal,
                  wibox.widget.systray(),
                  mytextclock,
                  s.mylayoutbox,
              },
          }
      end)
      -- }}}

      -- {{{ Mouse bindings
      root.buttons(gears.table.join(
          awful.button({ }, 3, function () mymainmenu:toggle() end),
          awful.button({ }, 4, awful.tag.viewnext),
          awful.button({ }, 5, awful.tag.viewprev)
      ))
      -- }}}

      -- {{{ Key bindings
      globalkeys = gears.table.join(
          -- Standard program
          awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
                    {description = "open a terminal", group = "launcher"}),
          awful.key({ modkey,           }, "e", function () awful.spawn(file_manager) end,
                    {description = "open file manager", group = "launcher"}),
          awful.key({ modkey, "Control" }, "r", awesome.restart,
                    {description = "reload awesome", group = "awesome"}),
          awful.key({ modkey,           }, "m", awesome.quit,
                    {description = "quit awesome", group = "awesome"}),
                    
          -- Similar to your Hyprland config
          awful.key({ modkey,           }, "q", function () client.focus:kill() end,
                    {description = "close", group = "client"}),
          awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end,
                    {description = "select previous layout", group = "layout"}),
          awful.key({ modkey,           }, "space", function () client.focus.fullscreen = not client.focus.fullscreen end,
                    {description = "toggle fullscreen", group = "client"}),
          awful.key({ modkey,           }, "t", function () client.focus.ontop = not client.focus.ontop end,
                    {description = "toggle keep on top", group = "client"}),
                    
          -- Rofi
          awful.key({ modkey,           }, "r", function () awful.spawn(menu_launcher) end,
                    {description = "run rofi", group = "launcher"}),
                    
          -- Layout manipulation
          awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
                    {description = "increase master width factor", group = "layout"}),
          awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
                    {description = "decrease master width factor", group = "layout"}),
                    
          -- Focus by direction (like your Hyprland config)
          awful.key({ modkey,           }, "Left",  function () awful.client.focus.bydirection("left") end,
                    {description = "focus left", group = "client"}),
          awful.key({ modkey,           }, "Right", function () awful.client.focus.bydirection("right") end,
                    {description = "focus right", group = "client"}),
          awful.key({ modkey,           }, "Up",    function () awful.client.focus.bydirection("up") end,
                    {description = "focus up", group = "client"}),
          awful.key({ modkey,           }, "Down",  function () awful.client.focus.bydirection("down") end,
                    {description = "focus down", group = "client"}),
                    
          -- Moving windows (like your Hyprland config)
          awful.key({ modkey, "Shift"   }, "Left",  function () awful.client.swap.bydirection("left") end,
                    {description = "swap with left client", group = "client"}),
          awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.bydirection("right") end,
                    {description = "swap with right client", group = "client"}),
          awful.key({ modkey, "Shift"   }, "Up",    function () awful.client.swap.bydirection("up") end,
                    {description = "swap with up client", group = "client"}),
          awful.key({ modkey, "Shift"   }, "Down",  function () awful.client.swap.bydirection("down") end,
                    {description = "swap with down client", group = "client"}),
                    
          -- Switch workspaces
          awful.key({ modkey,           }, "1", function () awful.screen.focused().tags[1]:view_only() end,
                    {description = "view tag #1", group = "tag"}),
          awful.key({ modkey,           }, "2", function () awful.screen.focused().tags[2]:view_only() end,
                    {description = "view tag #2", group = "tag"}),
          awful.key({ modkey,           }, "3", function () awful.screen.focused().tags[3]:view_only() end,
                    {description = "view tag #3", group = "tag"}),
          awful.key({ modkey,           }, "4", function () awful.screen.focused().tags[4]:view_only() end,
                    {description = "view tag #4", group = "tag"}),
          awful.key({ modkey,           }, "5", function () awful.screen.focused().tags[5]:view_only() end,
                    {description = "view tag #5", group = "tag"}),
          awful.key({ modkey,           }, "6", function () awful.screen.focused().tags[6]:view_only() end,
                    {description = "view tag #6", group = "tag"}),
          awful.key({ modkey,           }, "7", function () awful.screen.focused().tags[7]:view_only() end,
                    {description = "view tag #7", group = "tag"}),
          awful.key({ modkey,           }, "8", function () awful.screen.focused().tags[8]:view_only() end,
                    {description = "view tag #8", group = "tag"}),
          awful.key({ modkey,           }, "9", function () awful.screen.focused().tags[9]:view_only() end,
                    {description = "view tag #9", group = "tag"}),
                    
          -- Move windows to workspaces
          awful.key({ modkey, "Shift"   }, "1", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[1]) end end,
                    {description = "move focused client to tag #1", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "2", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[2]) end end,
                    {description = "move focused client to tag #2", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "3", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[3]) end end,
                    {description = "move focused client to tag #3", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "4", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[4]) end end,
                    {description = "move focused client to tag #4", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "5", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[5]) end end,
                    {description = "move focused client to tag #5", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "6", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[6]) end end,
                    {description = "move focused client to tag #6", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "7", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[7]) end end,
                    {description = "move focused client to tag #7", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "8", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[8]) end end,
                    {description = "move focused client to tag #8", group = "tag"}),
          awful.key({ modkey, "Shift"   }, "9", function () if client.focus then client.focus:move_to_tag(awful.screen.focused().tags[9]) end end,
                    {description = "move focused client to tag #9", group = "tag"})
      )

      clientkeys = gears.table.join(
          awful.key({ modkey,           }, "f",
              function (c)
                  c.fullscreen = not c.fullscreen
                  c:raise()
              end,
              {description = "toggle fullscreen", group = "client"}),
          awful.key({ modkey, "Shift"   }, "f",      function (c) c.floating = not c.floating end,
                    {description = "toggle floating", group = "client"})
      )

      -- Bind all key numbers to tags.
      clientbuttons = gears.table.join(
          awful.button({ }, 1, function (c)
              c:emit_signal("request::activate", "mouse_click", {raise = true})
          end),
          awful.button({ modkey }, 1, function (c)
              c:emit_signal("request::activate", "mouse_click", {raise = true})
              awful.mouse.client.move(c)
          end),
          awful.button({ modkey }, 3, function (c)
              c:emit_signal("request::activate", "mouse_click", {raise = true})
              awful.mouse.client.resize(c)
          end)
      )

      -- Set keys
      root.keys(globalkeys)
      -- }}}

      -- {{{ Rules
      -- Rules to apply to new clients (through the "manage" signal).
      awful.rules.rules = {
          -- All clients will match this rule.
          { rule = { },
            properties = { border_width = 2,
                           border_color = beautiful.border_normal,
                           focus = awful.client.focus.filter,
                           raise = true,
                           keys = clientkeys,
                           buttons = clientbuttons,
                           screen = awful.screen.preferred,
                           placement = awful.placement.no_overlap+awful.placement.no_offscreen
           }
          },

          -- Floating clients.
          { rule_any = {
              instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
              },
              class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"},

              -- Note that the name property shown in xprop might be set slightly after creation of the client
              -- and the name shown there might not match defined rules here.
              name = {
                "Event Tester",  -- xev.
              },
              role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
              }
            }, properties = { floating = true }},

          -- JetBrains IDEs (e.g., IntelliJ IDEA)
          { rule = { class = "jetbrains-idea" },
            properties = { 
              floating = false,
              maximized = false,
              titlebars_enabled = false
            }
          },
      }
      -- }}}

      -- {{{ Signals
      -- Signal function to execute when a new client appears.
      client.connect_signal("manage", function (c)
          -- Set the windows at the slave,
          -- i.e. put it at the end of others instead of setting it master.
          -- if not awesome.startup then awful.client.setslave(c) end

          if awesome.startup
            and not c.size_hints.user_position
            and not c.size_hints.program_position then
              -- Prevent clients from being unreachable after screen count changes.
              awful.placement.no_offscreen(c)
          end
      end)

      -- Enable sloppy focus, so that focus follows mouse.
      client.connect_signal("mouse::enter", function(c)
          c:emit_signal("request::activate", "mouse_enter", {raise = false})
      end)

      client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
      client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
      -- }}}

      -- Autostart applications
      awful.spawn.with_shell("nitrogen --restore")
      awful.spawn.with_shell("picom")
      awful.spawn.with_shell("dunst")
      awful.spawn.with_shell("blueman-applet")
      awful.spawn.with_shell("/usr/bin/gnome-keyring-daemon --start")
      awful.spawn.with_shell("polkit-gnome-authentication-agent-1")
    '';
  };

  # Configure a theme for AwesomeWM
  xdg.configFile."awesome/theme.lua" = {
    text = ''
      local theme_assets = require("beautiful.theme_assets")
      local xresources = require("beautiful.xresources")
      local dpi = xresources.apply_dpi
      local gfs = require("gears.filesystem")
      local themes_path = gfs.get_themes_dir()

      local theme = {}

      theme.font          = "Cartograph CF Nerd Font 20"

      -- Nord color scheme (similar to your Hyprland theme)
      theme.bg_normal     = "#2e3440"
      theme.bg_focus      = "#5e81ac"
      theme.bg_urgent     = "#bf616a"
      theme.bg_minimize   = "#3b4252"
      theme.bg_systray    = theme.bg_normal

      theme.fg_normal     = "#eceff4"
      theme.fg_focus      = "#eceff4"
      theme.fg_urgent     = "#eceff4"
      theme.fg_minimize   = "#eceff4"

      theme.border_width  = dpi(2)
      theme.border_normal = "#595959aa"
      theme.border_focus  = "#cf8024"
      theme.border_marked = "#9d3522"

      -- There are other variable sets
      -- overriding the default one when
      -- defined, the sets are:
      -- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
      -- tasklist_[bg|fg]_[focus|urgent]
      -- titlebar_[bg|fg]_[normal|focus]
      -- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
      -- mouse_finder_[color|timeout|animate_timeout|radius|factor]
      -- prompt_[fg|bg|fg_cursor|bg_cursor|font]
      -- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

      -- Variables set for theming notifications:
      -- notification_font
      -- notification_[bg|fg]
      -- notification_[width|height|margin]
      -- notification_[border_color|border_width|shape|opacity]

      -- Variables set for theming the menu:
      -- menu_[bg|fg]_[normal|focus]
      -- menu_[border_color|border_width]
      theme.menu_submenu_icon = themes_path.."default/submenu.png"
      theme.menu_height = dpi(24)
      theme.menu_width  = dpi(150)

      -- You can add as many variables as
      -- you wish and access them by using
      -- beautiful.variable in your rc.lua
      theme.bg_widget = "#3b4252"

      -- Define the image to load
      theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
      theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

      theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
      theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

      theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
      theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
      theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
      theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

      theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
      theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
      theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
      theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

      theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
      theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
      theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
      theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

      theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
      theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
      theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
      theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

      -- You can use your own layout icons like this:
      theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
      theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
      theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
      theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
      theme.layout_max = themes_path.."default/layouts/maxw.png"
      theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
      theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
      theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
      theme.layout_tile = themes_path.."default/layouts/tilew.png"
      theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
      theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
      theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
      theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
      theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
      theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
      theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

      -- Generate Awesome icon:
      theme.awesome_icon = theme_assets.awesome_icon(
          theme.menu_height, theme.bg_focus, theme.fg_focus
      )

      -- Define the icon theme for application icons. If not set then the icons
      -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
      theme.icon_theme = "Adwaita"

      return theme
    '';
  };

  # Configure dunst for notifications (similar to your swaync setup)
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "10x50";
        origin = "top-right";
        transparency = 0;
        frame_color = "#5e81ac";
        font = "Cartograph CF Nerd Font 20";
        corner_radius = 4;
      };
      urgency_low = {
        background = "#2e3440";
        foreground = "#eceff4";
        timeout = 10;
      };
      urgency_normal = {
        background = "#3b4252";
        foreground = "#eceff4";
        timeout = 10;
      };
      urgency_critical = {
        background = "#bf616a";
        foreground = "#eceff4";
        timeout = 0;
      };
    };
  };
}
