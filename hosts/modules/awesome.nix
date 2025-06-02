{ config, pkgs, lib, ... }:

{
  # Enable X11 with AwesomeWM
  services.xserver = {
    # No need to enable xserver here, it's in the display-manager module
    
    # Remove the displayManager section entirely
    
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
      ];
    };
  };

  # Install necessary X11 and supporting packages
  environment.systemPackages = with pkgs; [
    # X utilities
    xclip
    xorg.xrandr
    xorg.xrdb
    xorg.xset
    xorg.xsetroot
    
    # Authentication agent for X11
    polkit_gnome
    
    # Keep consistency with your Hyprland setup
    gnome-keyring
  ];
}
