{
  config,
  pkgs,
  ...
}: {
  # Install the necessary packages.
  home.packages = with pkgs; [
    wofi
    xfce.thunar
    waybar
    swaynotificationcenter
    blueman
    hyprpolkitagent
    grim
    slurp
    wl-clipboard
    gnome-keyring
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["~/Pictures/backgrounds/wolf_moon_red.jpg"];
      wallpaper = [", ~/Pictures/backgrounds/wolf_moon_red.jpg"];
    };
  };

  # Hyprland window manager configuration.
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      #####################
      # MONITOR SETTINGS  #
      #####################
      monitor = [
        "DP-2,1920x1080@144,0x0,auto"
        "DP-1,1920x1080@165,1920x0,auto"
        ",preferred,auto,auto"
      ];

      ##########################
      # ENVIRONMENT VARIABLES  #
      ##########################
      # (Some options might be more appropriate in your environment configuration.)
      env = [
        "XCURSOR_SIZE,${toString config.home.pointerCursor.size}"
        "HYPRCURSOR_SIZE,${toString config.home.pointerCursor.size}"
        "GTK_THEME,Adwaita:dark"
        "QT_STYLE_OVERRIDE,Adwaita-Dark"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      ###############################
      # PROGRAM PATHS / VARIABLES   #
      ###############################
      "$term" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun --allow-images";

      #####################
      # AUTOSTART APPS    #
      #####################
      # These commands will be executed once when Hyprland starts.
      exec-once = [
        "waybar"
        "hyprpaper"
        "hypridle"
        "swaync"
        "systemctl --user start hyprpolkitagent"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "blueman-applet"
        "wl-paste -t text -w xclip -selection clipboard"
        "hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}"
        "eval $(/usr/bin/gnome-keyring-daemon --start); export SSH_AUTH_SOCK"
      ];

      #####################
      # XWAYLAND SETTINGS #
      #####################
      xwayland.force_zero_scaling = true;

      #############################
      # GENERAL / LOOK-AND-FEEL    #
      #############################
      general = {
        resize_on_border = false;
        layout = "dwindle";
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(cf8024ff) rgba(9d3522ff) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        allow_tearing = false;
      };

      #############################
      # DECORATION SETTINGS       #
      #############################
      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      #####################
      # ANIMATIONS        #
      #####################
      animations = {
        enabled = true;
        bezier = "myBezier,0.05,0.9,0.1,1.00";
        animation = [
          "windows,1,7,myBezier"
          "windowsOut,1,7,default,popin 80%"
          "border,1,10,default"
          "borderangle,1,8,default"
          "fade,1,7,default"
          "workspaces,1,6,default"
        ];
      };

      #####################
      # DWINDLE LAYOUT    #
      #####################
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      #####################
      # MASTER LAYOUT     #
      #####################
      master = {new_status = "master";};

      #####################
      # MISCELLANEOUS     #
      #####################
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      #####################
      # INPUT CONFIGURATIONS  #
      #####################
      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
      };

      gestures.workspace_swipe = false;

      #####################
      # KEYBINDINGS       #
      #####################
      # Define your modifier and keybindings.
      "$mod" = "SUPER";

      bind = [
        # --- Application & Basic Bindings ---
        "$mod, RETURN, exec, $term" # Open terminal
        "$mod, Q, killactive" # Close window
        "$mod, M, exit" # Exit Hyprland
        "$mod, E, exec, $fileManager" # Open file manager
        "$mod, F, togglefloating" # Toggle floating mode
        "$mod, T, togglesplit" # Toggle split layout

        # --- Fullscreen ---
        "$mod SHIFT, SPACE, fullscreen, 1"
        "$mod, SPACE, fullscreen, 2"

        # --- Session ---
        "$mod, L, exec, hyprlock --immediate & sleep 1 && systemctl suspend &"
        #"CTRL ALT, delete, exec, hyprlock -f & sleep 1 && systemctl suspend &"

        # --- Focus & Movement --- (arrow keys only)
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # --- Moving Windows --- (arrow keys only)
        "$mod SHIFT, left, movewindow, mon:l"
        "$mod SHIFT, right, movewindow, mon:r"
        "$mod SHIFT, up, movewindow, mon:u"
        "$mod SHIFT, down, movewindow, mon:d"

        # --- Moving Workspace Between Monitors --- (arrow keys only)
        "$mod CTRL, left, movecurrentworkspacetomonitor, l"
        "$mod CTRL, right, movecurrentworkspacetomonitor, r"
        "$mod CTRL, up, movecurrentworkspacetomonitor, u"
        "$mod CTRL, down, movecurrentworkspacetomonitor, d"

        # --- Switching Workspaces ---
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, n, workspace, empty"
        "$mod ALT CTRL, right, workspace, r+1"
        "$mod ALT CTRL, left, workspace, r-1"

        # --- Moving Windows to Workspaces ---
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod SHIFT, n, movetoworkspace, empty"

        # --- Special Workspaces (Spotify & Dev) ---
        "$mod, S, togglespecialworkspace, Spotify"
        "$mod SHIFT, S, movetoworkspace, special:Spotify"
        "$mod, D, togglespecialworkspace, Dev"
        "$mod SHIFT, D, movetoworkspace, special:Dev"
        "$mod, B, togglespecialworkspace, Browser"
        "$mod SHIFT, B, movetoworkspace, special:Browser"

        # --- Cycling Workspaces ---
        "ALT, TAB, cyclenext"
        "$mod, TAB, workspace, e+1"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod SHIFT, mouse:272, resizewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindr = "$mod, SUPER_L, exec, pkill wofi || $menu";

      bindl = [
        ''
          ,switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
        '',switch:off:Lid Switch, exec, bash -c "sleep 0.5 && hyprctl reload"''
      ];

      bindle = [
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
        ",XF86AudioMute, exec, pamixer -t"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",Print, exec, grim - | wl-copy"
        ''SHIFT, Print, exec, grim -g "$(slurp)" - | wl-copy''
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      windowrule = [
        "float, class:^(nmtui-popup)$"
        "center, class:^(nmtui-popup)$"
        "size 600 400, class:^(nmtui-popup)$"

        "float, title:^(Network Connections)$"
        "center, title:^(Network Connections)$"
        "size 800 600, title:^(Network Connections)$"
      ];

      windowrulev2 = [
        # Fix tooltips (always have a title of `win.<id>`)
        "noinitialfocus, class:^(.*jetbrains.*)$, title:^(win.*)$"
        "nofocus, class:^(.*jetbrains.*)$, title:^(win.*)$"

        # Fix tab dragging (always have a single space character as their title)
        "noinitialfocus, class:^(.*jetbrains.*)$, title:^\\s$"
        "nofocus, class:^(.*jetbrains.*)$, title:^\\s$"
      ];
    };
  };
}
