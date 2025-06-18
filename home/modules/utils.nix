{ config, pkgs, ... }:

{
  # Use the nixpkgs instance passed to the module
  home.packages = with pkgs; [ 
    kdePackages.merkuro
  ];
}