{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libgcc
    gcc
    gnumake
    (python312.withPackages (ppkgs: [ ppkgs.numpy ppkgs.numba ppkgs.scipy ]))
  ];
}

