{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-lspconfig

      nvim-cmp
      cmp-nvim-lua
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp

      # probably more cmp plugins here
      luasnip
      cmp_luasnip

      telescope-nvim

      nvim-tree-lua
      nvim-web-devicons

      vim-terraform

      tokyonight-nvim
    ];
    extraConfig = ''
      set autoindent
      set autoread
      set backspace=indent,eol,start
      set expandtab
      set number
      set termguicolors
      set shiftwidth=2
      set smarttab
      set completeopt=menu,menuone,noselect
      set cursorline
      colorscheme tokyonight

lua << EOF
        require('lualine').setup({
          options = {
            theme = 'tokyonight'
          },
        })

        local luasnip = require('luasnip')

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
        
        -- cmp autocomplete
	local cmp = require('cmp')
	cmp.setup({
	  snippet = {
	    expand = function(args)
	      luasnip.lsp_expand(args.body)
	    end,
	  },
	  mapping = {
	    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
	    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c'}),
	    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
	    ['<C-y>'] = cmp.config.disable,
	    ['<C-e>'] = cmp.mapping({
	      i = cmp.mapping.abort(),
	      c = cmp.mapping.close(),
	    }),
	    ['<CR>'] = cmp.mapping.confirm({ select = true }),
	  },
	  sources = cmp.config.sources({
	    { name = 'nvim_lsp' },
	    { name = 'luasnip' },
	  }, {
	    { name = 'buffer' },
	  })
        })

	cmp.setup.cmdline('/', {
	  sources = {
	    { name = 'buffer' }
	  }
	})

	cmp.setup.cmdline(':', {
	  sources = cmp.config.sources({
	    { name = 'path' }
	  }, {
	    { name = 'cmdline' }
	  })
	})

        -- lsp setup
        local lspconfig = require('lspconfig')
	local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

        lspconfig.terraformls.setup({
          capabilities = capabilities,
        })
        vim.api.nvim_create_autocmd({"BufWritePre"}, {
          pattern = {"*.tf", "*.tfvars"},
          callback = vim.lsp.buf.formatting_sync,
        })

	lspconfig.gopls.setup({
	  capabilities = capabilities
        })

        lspconfig.yamlls.setup({
          capabilities = capabilities,
          settings = {
            yaml = {
              format = {
                enable = true,
              },
              validate = true,
              hover = true,
              completion = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
            },
          },
        })

        -- lualine
	require('lualine').setup()

EOF
    '';
    extraPackages = with pkgs; [
      gopls
      yaml-language-server
      terraform-ls
    ]; # probably throw lsp servers in here?
  };
}
