{ config, pkgs, ... }:

{
  # Use the nixpkgs instance passed to the module
  home.packages = with pkgs; [ 
    teams-for-linux 
    
    # If your flake.nix has the overlay properly set up:
    openconnect-sso
  ];
}

