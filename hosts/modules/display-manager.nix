{ config, pkgs, lib, ... }:

{
  # Enable the display manager
  services.xserver.enable = true;
  
  # Configure GDM display manager
  services.xserver.displayManager.gdm = {
    enable = true;
    # Enable Wayland support (especially for Hyprland)
    wayland = true;
    # Set your default session if desired
    # defaultSession = "hyprland"; # or "none+awesome" for AwesomeWM
  };
  
  # Authentication and keyring support for all sessions
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  
  # Common utilities needed for the login screen
  environment.systemPackages = with pkgs; [
    gnome-keyring
    polkit_gnome
  ];
}