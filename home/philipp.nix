{ pkgs, nvf, ... }:

{
  imports = [
    nvf.homeManagerModules.default
    ./common.nix
    ./modules/fish.nix
    ./modules/asl.nix
    ./modules/editor.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/shcs.nix
    ./modules/dev.nix
  ];

  home.packages = with pkgs; [ tlp brightnessctl zoom ];
}
