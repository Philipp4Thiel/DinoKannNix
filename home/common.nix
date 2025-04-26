{ config, pkgs, ... }:

{
  home.username = "philipp";
  home.homeDirectory = "/home/philipp";

  home.packages = with pkgs; [
    neovim
    zathura
    ripgrep
    bat
    fd
    zoxide
    tmux
    vscode
    goofcord
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
    obsidian
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

