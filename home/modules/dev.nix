{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ libgcc gcc gnumake ];
}

