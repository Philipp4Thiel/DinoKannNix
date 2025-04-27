{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = false;
    withNodeJs = true; # for copilot
    withPython3 = true; # for python plugins
    extraConfig = ''
      map <Space> <Leader>
      :set number
      :set relativenumber
      :set expandtab
      :set tabstop=4
      :set shiftwidth=4
      :set scrolloff=10
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup(
            {
              options = { theme = 'onedark' },
              sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff' },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
              }
            }
          )
        '';
      } # Status Line
      {
        plugin = nvim-treesitter.withAllGrammars; # Syntax Highlighting
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = { enable = true}
          }
        '';
      }
      {
        plugin = null-ls-nvim;
        type = "lua";
        config = ''
          local null_ls = require("null-ls")
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          null_ls.setup({
              sources = {
                  null_ls.builtins.formatting.alejandra.with({
                      command = "${pkgs.alejandra}/bin/alejandra"
                  }), null_ls.builtins.formatting.lua_format.with({
                      command = "${pkgs.luaformatter}/bin/lua-format"
                  })
              },

              on_attach = function(client, bufnr)
                  if client.supports_method("textDocument/formatting") then
                      vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
                      vim.api.nvim_create_autocmd("BufWritePre", {
                          group = augroup,
                          buffer = bufnr,
                          callback = function()
                              vim.lsp.buf.format({
                                  bufnr = bufnr,
                                  filter = function(client)
                                      return client.name == "null-ls"
                                  end
                              })
                          end
                      })
                  end
              end
          })
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          require('lspconfig').nil_ls.setup({
            cmd = { "${pkgs.nil}/bin/nil" }
          })
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup{}
        '';
      }
    ];
  };

  # Optional: Install LSP servers system-wide
  home.packages = with pkgs; [
    rust-analyzer
    clang-tools # for C
    haskell-language-server
    ocamlPackages.ocaml-lsp
    scala_3 # for Scala (you might want metals separately)
    metals
  ];
}
