{ config, pkgs, ... }:

let
  # Define the Lua config inline
  nvimConfig = ''
    -- Plugin manager (lazy.nvim) initialization
    require("lazy").setup({
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lualine/lualine.nvim",
      "nvim-telescope/telescope.nvim",
      "github/copilot.vim",
      "folke/which-key.nvim"
    })

    -- Mason setup
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "rust_analyzer", "clangd", "hls", "ocamllsp", "metals", "nil_ls" }
    })

    -- Setup LSP servers
    local lspconfig = require('lspconfig')

    local servers = { "pyright", "clangd", "rust_analyzer", "hls", "ocamllsp", "metals", "nil_ls" }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(_, bufnr)
          local opts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        end
      }
    end

    -- nvim-cmp setup
    local cmp = require'cmp'
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' }
      })
    })

    -- Treesitter setup
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "python", "c", "rust", "nix", "haskell", "ocaml", "scala" },
      highlight = {
        enable = true
      }
    }

    -- Lualine setup
    require('lualine').setup()

    -- Telescope
    require('telescope').setup{}

    -- Optional: GitHub Copilot toggle
    vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot toggle<CR>", { noremap = true, silent = true })
  '';

in {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true; # for copilot
    withPython3 = true; # for python plugins
  };

  home.file."${config.home}/.config/nvim/init.lua" = {
    text = nvimConfig; # This places the Lua configuration
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
