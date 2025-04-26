{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libgcc
    gcc
    gnumake
    python312
    python312Packages.numpy
  ];
}

