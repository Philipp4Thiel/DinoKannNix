{
  pkgs,
  nvf,
  inputs,
  ...
}: {
  imports = [
    nvf.homeManagerModules.default
    ./common.nix
    ./modules/fish.nix
    ./modules/asl.nix
    ./modules/editor.nix
    ./modules/cursor.nix
    ./modules/hyprland.nix
    ./modules/awesome.nix
    ./modules/waybar.nix
    ./modules/shcs.nix
    ./modules/dev.nix
    ./modules/utils.nix
  ];

  home.packages = with pkgs; [tlp brightnessctl zoom];
}
