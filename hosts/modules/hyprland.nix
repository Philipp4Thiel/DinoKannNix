{ config, pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprlock
    hypridle
    hyprpolkitagent
    hyprpicker
    gnome-keyring
  ];
}

