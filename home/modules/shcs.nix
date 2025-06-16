{ config, pkgs, ... }:

{
  # Use the nixpkgs instance passed to the module
  home.packages = with pkgs; [ 
    teams-for-linux 
    
    poetry
    keepassxc
    stdenv.cc  # Include C compiler
    zlib       # Include zlib
    ruff

    # Add direnv for directory-specific environment variables
    direnv
  ];
  
  # Configure direnv to hook into fish shell
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Adds better nix support
  };
  
  # Configure fish to automatically load direnv
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Hook direnv into fish shell
      eval (direnv hook fish)
    '';
  };
}

