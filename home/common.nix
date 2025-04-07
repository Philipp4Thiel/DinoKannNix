{ config, pkgs, ... }:

{
  home.username = "philipp";
  home.homeDirectory = "/home/philipp";

  home.packages = with pkgs; [ neovim ripgrep bat fd zoxide tmux kitty vscode ];

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    userName = "Bilopp";
    userEmail = "philipp@thiel.team";
  };

  home.stateVersion = "24.11";
}

