{ config, pkgs, ... }:

{
  home.username = "philipp";
  home.homeDirectory = "/home/philipp";

  home.packages = with pkgs; [
    neovim
    ripgrep
    bat
    fd
    zoxide
    tmux
  ];
  
  # shell
  programs.starship.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      eval "$(starship init zsh)"
    '';
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
    };
  };

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    userName = "Bilopp";
    userEmail = "philipp@thiel.team";
  };

  home.stateVersion = "24.11";
}

