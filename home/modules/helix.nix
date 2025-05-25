{ config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "starlight";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      editor.line-number = "relative";
      # line-number = "relative";
      keys.normal = { K = "hover"; };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
    }];
  };
  home.packages = with pkgs; [
    # lsp/formatting
    # python 
    ruff
    python312Packages.python-lsp-server
    python312Packages.jedi
    # c/cpp
    clang-tools
    lldb_19
    # rust
    rust-analyzer
    # scala
    metals
    # nix
    nil
  ];
}
