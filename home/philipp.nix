{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/fish.nix
    ./modules/helix.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/work.nix
  ];

  home.packages = with pkgs; [ tlp brightnessctl ];
}
