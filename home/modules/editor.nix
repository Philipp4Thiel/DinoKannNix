{ config, pkgs, inputs, ... }: {
  programs.nvf.defaultEditor = true;
  imports = [./nvim.nix ./helix.nix];
}
