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

  services.gnome.gnome-keyring.enable = true;

  security.pam.services.hyprland.enableGnomeKeyring = true;
}

