{ config, pkgs, ... }:

{
  services.xserver.enable = false;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}

