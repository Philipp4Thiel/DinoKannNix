{ config, pkgs, ... }:

{
  # Use the nixpkgs instance passed to the module
  home.packages = with pkgs; [ 
    teams-for-linux 
    
    # Official UZH-recommended VPN client
    pulsesecure
  ];
}

