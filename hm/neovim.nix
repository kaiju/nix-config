{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-lspconfig
      bufferline-nvim

      nvim-cmp
      cmp-nvim-lua
      cmp-buffer
      cmp-path
      cmp-cmdline

      telescope-nvim

      nvim-tree-lua
      nvim-web-devicons

      vim-terraform

      tokyonight-nvim
    ];
    extraLuaConfig = ''
      -- options
      vim.o.autoindent = true
      vim.o.autoread = true
      vim.o.backspace = "indent,eol,start"
      vim.o.expandtab = true
      vim.o.number = true
      vim.o.termguicolors = true
      vim.o.shiftwidth = 2
      vim.o.smarttab = true
      vim.o.completeopt = "menu,menuone,noselect"
      vim.o.cursorline = true
      vim.o.winborder = "solid"

      
      -- color scheme
      vim.cmd.colorscheme("tokyonight")
      require('lualine').setup({
        options = {
          theme = 'tokyonight'
        },
      })

      local bufferline = require('bufferline')
      bufferline.setup{}

      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = "buffer" }
        }
      })
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })

      -- nvim tree
      local nvimtree = require('nvim-tree')
      nvimtree.setup({
        renderer = {
          indent_markers = {
            enable = true,
          },
          highlight_opened_files = "all",
        },
      })

      require('nvim-web-devicons').setup()
      
      -- lsp setup
      vim.lsp.enable({'ruff', 'pyright'})
      vim.lsp.config('pyright', {
        settings = {
          -- we could write a bunch of code to set python.pythonPath to venv/ if it exists
          pyright = {
            disableOrganizeImports = true
          }
        }
      })
      vim.lsp.enable({'terraformls'})
      vim.lsp.enable({'nil_ls'})
      vim.lsp.enable({'gopls'})
      vim.lsp.enable({'yamlls'})

      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
          prefix = "",
          suffix = " ",
          spacing = 2,
        }
      })

      -- TODO-
      --       pyright venv
      --       diagnostics signs
      --       organize imports on save:
      --       vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })

      -- set up LSP magic on server attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- autocompletion
          if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
          end

          -- lsp format on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = ev.buf,
            callback = function()
              vim.lsp.buf.format { async = false, id = ev.data.client_id }
            end,
          })

        end,
      })

    '';
    extraPackages = with pkgs; [
      nil
    ]; # probably throw lsp servers in here?
  };
}
