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

      vim-terraform
    ];
    extraConfig = ''
      set autoindent
      set autoread
      set backspace=indent,eol,start
      set expandtab
      set number
      set shiftwidth=2
      set smarttab
      set completeopt=menu,menuone,noselect

lua << EOF
        local luasnip = require('luasnip')

	local nvimtree = require('nvim-tree')
	nvimtree.setup{}
        
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

        local lspconfig = require('lspconfig')
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

	lspconfig.gopls.setup{
	  capabilities = capabilities
        }

        lspconfig.yamlls.setup{
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
        }

	require('lualine').setup()

EOF
    '';
    extraPackages = with pkgs; [
      gopls
      yaml-language-server
    ]; # probably throw lsp servers in here?
  };
}
