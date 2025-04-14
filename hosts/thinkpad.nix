{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/hyprland.nix
    ./hardware_configurations/thinkpad.nix
  ];

  networking.hostName = "thinkpad";

  # Laptop specific stuff
  environment.systemPackages = with pkgs; [ bluez blueman ];

  hardware.bluetooth.enable = true;
}

