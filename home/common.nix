{
  config,
  pkgs,
  ...
}: {
  home.username = "philipp";
  home.homeDirectory = "/home/philipp";

  home.packages = with pkgs; [
    zathura
    ripgrep
    bat
    fd
    zoxide
    tmux
    vscode
    spotify
    goofcord
    obsidian
    gparted

    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
  ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font Mono";
    settings = {
      background_opacity = 0.7;
      confirm_os_window_close = 0;
    };
  };

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    userName = "Bilopp";
    userEmail = "philipp@thiel.team";

    # Add global ignore patterns
    ignores = [
      ".envrc"
      "shell.nix"
      ".direnv"
    ];
  };

  home.stateVersion = "24.11";
}
