{ config, pkgs, ... }:

{
  # Disable the X server since Hyprland is a Wayland compositor.
  services.xserver.enable = false;

  # Enable Hyprland with XWayland support (for legacy apps, if needed).
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable SDDM as the display manager with Wayland support.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    # Optionally set a theme; change "breeze" to your preferred SDDM theme.
    theme = "breeze";
  };
}

