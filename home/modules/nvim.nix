{ pkgs, inputs, ... }:
let
  nvf = inputs.nvf.packages.${pkgs.system}.maximal;
in {
  home.packages = [
    nvf
  ];
}
