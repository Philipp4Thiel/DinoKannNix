{ config, pkgs, ... }: {
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
}
