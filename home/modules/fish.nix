{ config, pkgs, ... }: {
  # shell
  home.packages = with pkgs; [ lsd zoxide ];
  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      alias old_ls="ls"
      alias ls="lsd"
      set fish_greeting
      starship init fish | source
      zoxide init fish --cmd cd | source
    '';
  };
}
