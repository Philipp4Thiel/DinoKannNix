{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/display-manager.nix
    ./modules/hyprland.nix
    ./modules/awesome.nix
    ./modules/gnome.nix
    ./hardware_configurations/thinkpad.nix
  ];

  networking.hostName = "thinkpad";

  # Laptop specific stuff
  environment.systemPackages = with pkgs; [ bluez blueman ];

  hardware.bluetooth.enable = true;
}

