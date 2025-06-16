{ config, pkgs, ... }:

{
  # Use the nixpkgs instance passed to the module
  home.packages = with pkgs; [ 
    teams-for-linux 
    
    poetry
    keepassxc
    python312
    # NetworkManager plugin for Pulse VPN
    networkmanager-openconnect
    openconnect
  ];
}

