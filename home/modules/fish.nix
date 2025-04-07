{ config, pkgs, ... }: {
  # shell
  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      starship init fish | source
    '';
  };
}
