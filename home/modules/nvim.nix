{pkgs, ...}: {
  # Disable built-in Neovim if it was enabled previously
  programs.neovim.enable = false;
  programs.nvf = {
    enable = true;
  };
}
