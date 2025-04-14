{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ pamixer ];
  # Create the Waybar configuration file at ~/.config/waybar/config
  home.file.".config/waybar/config" = {
    text = ''
      {
          "layer": "top",
          "position": "top",
          "mode": "dock",
          "exclusive": true,
          "passthrough": false,
          "gtk-layer-shell": true,
          "height": 0,
          "modules-left": [
              "hyprland/workspaces"
          ],
          "modules-center": ["hyprland/window"],
          "modules-right": [
              "tray",
              //"network",
              "wireplumber",
              "backlight",
              "battery",
              "clock",
              "custom/notification"
          ],

          "hyprland/window": {
              "separate-outputs": true,
              "icon": true,
              "format": "{initialTitle}"
          },
          "hyprland/workspaces": {
              "disable-scroll": true,
              "all-outputs": true,
              "on-click": "activate",
              "show-special": true
          },
          "tray": {
              "icon-size": 13,
              "spacing": 10
          },
          "clock": {
              "format": " {:%R    %d.%m.%Y}",
              "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
          },
          "backlight": {
              "device": "intel_backlight",
              "format": "{icon} {percent}%",
              "format-icons": ["\udb80\udcdb", "\udb80\udcdf", "\udb80\udce0"],
              "on-scroll-up": "brightnessctl set 1%+",
              "on-scroll-down": "brightnessctl set 1%-",
              "min-length": 6
          },
          "battery": {
              "states": {
                  "good": 95,
                  "warning": 30,
                  "critical": 20
              },
              "format": "{icon} {capacity}%",
              "format-charging": " {capacity}%",
              "format-plugged": " {capacity}%",
              "format-alt": "{time} {icon}",
              "format-icons": [
                "\udb80\udc7a",
                "\udb80\udc7b",
                "\udb80\udc7c",
                "\udb80\udc7d",
                "\udb80\udc7e",
                "\udb80\udc7f",
                "\udb80\udc80",
                "\udb80\udc81",
                "\udb80\udc82",
                "\udb80\udc79"
              ],
          },
          "wireplumber": {
              "format": "{icon} {volume}%",
              "tooltip": false,
              "format-muted": " Muted",
              "on-click": "pamixer -t",
              "on-click-right": "pkill pavucontrol || pavucontrol",
              "on-scroll-up": "pamixer -i 5",
              "on-scroll-down": "pamixer -d 5",
              "scroll-step": 5,
              "format-icons": {
                  "headphone": "",
                  "hands-free": "",
                  "headset": "",
                  "phone": "",
                  "portable": "",
                  "car": "",
                  "default": ["", "", ""]
              }
          },
          "network": {
              "format-icons": ["󰤯 ", "󰤟 ", "󰤢 ", "󰤥 ", "󰤨 "],
              "format-wifi": "{icon}  {essid}",
              "format-ethernet": "",
              "format-disconnected": "󰤮  disconnected"
          },
          "custom/notification": {
              "tooltip": false,
              "format": "{icon}",
              "format-icons": {
                  "notification": "󱅫",
                  "none": "",
                  "dnd-notification": " ",
                  "dnd-none": "󰂛",
                  "inhibited-notification": " ",
                  "inhibited-none": "",
                  "dnd-inhibited-notification": " ",
                  "dnd-inhibited-none": " "
              },
              "return-type": "json",
              "exec-if": "which swaync-client",
              "exec": "swaync-client -swb",
              "on-click": "swaync-client -t -sw",
              "on-click-right": "swaync-client -d -sw",
              "escape": true
          },
      }
    '';
  };

  # Create the Waybar style file at ~/.config/waybar/style.css
  home.file.".config/waybar/style.css" = {
    text = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: Cartograph CF Nerd Font, monospace;
        font-size: 14px;
      }

      window#waybar {
        background-color: #2e3440;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.5;
      }

      #workspaces {
        background-color: transparent;
      }

      #workspaces button {
        all: initial;
        /* Remove GTK theme values (waybar #1351) */
        min-width: 0;
        /* Fix weird spacing in materia (waybar #450) */
        box-shadow: inset 0 -3px transparent;
        /* Use box-shadow instead of border so the text isn't offset */
        padding: 6px 18px;
        margin: 6px 3px;
        border-radius: 4px;
        background-color: #3b4252;
        color: #eceff4;
      }

      #workspaces button.visible {
        color: #eceff4;
        background-color: #5e81ac;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #eceff4;
        background-color: #81a1c1;
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
      }

      #memory,
      #custom-power,
      #battery,
      #backlight,
      #pulseaudio,
      #wireplumber,
      #network,
      #clock,
      #custom-notification,
      #tray {
        border-radius: 4px;
        margin: 6px 3px;
        padding: 6px 12px;
        background-color: #1e1e2e;
        color: #eceff4;
      }

      #battery {
        background-color: #a3be8c;
        color: #2e3440;
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        background-color: #bf616a;
        color: #2e3440;
      }

      #battery.charging {
        background-color: #ebcb8b;
        color: #181825;
      }

      #network {
        background-color: #3b4252;
        padding-right: 17px;
      }
      #network.disconnected {
        background-color: #bf616a;
        padding-right: 17px;
        color: #2e3440;
      }

      #tray,
      #pulseaudio,
      #wireplumber,
      #custom-notification,
      #clock {
        background-color: #3b4252;
      }
    '';
  };
}

