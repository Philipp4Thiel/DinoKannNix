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
    vscode
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
  ];

  programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font Mono";
  };

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    userName = "Bilopp";
    userEmail = "philipp@thiel.team";
  };

  home.stateVersion = "24.11";
}

