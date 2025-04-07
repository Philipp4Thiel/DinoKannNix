{ config, pkgs, ... }: {
  home.packages = with pkgs; [ kitty wofi xfce.thunar ];
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [ ",preferred,auto,auto" ];

      gestures.workspace_swipe = false;
      input.touchpad.natural_scroll = false;

      general = {
        resize_on_border = false;
        layout = "dwindle";

        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(cf8024ff) rgba(9d3522ff) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      xwayland.force_zero_scaling = true;

      "$mod" = "SUPER";

      "$term" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun --allow-images";

      bind = [
        # Apps
        "$mod, RETURN, exec, $term"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, $fileManager"

        # fullscreen
        "$mod SHIFT, SPACE, fullscreen, 1"
        "$mod, SPACE, fullscreen, 2"

      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]) 9));
      bindm = [
        # mouse
        "$mod, mouse:272, movewindow"
        "$mod SHIFT, mouse:272, resizewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindr = "SUPER, SUPER_L, exec, pkill wofi || $menu";
    };
  };
}
