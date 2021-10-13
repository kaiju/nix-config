{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    exa
    ranger
    bitwarden-cli
  ];

  programs.htop = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      directory = {
        truncation_length = 8;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "josh@kaiju.net";
    userName = "Josh";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      ls = "${pkgs.exa}/bin/exa -F";
      vi = "${pkgs.vim}/bin/vim";
    };

    initExtra = ''

      # Nix-friendly terminfo paths
      TERMINFO_DIRS="$HOME/.nix-profile/share/terminfo:$TERMINFO_DIRS"

      # Pull in Nix paths
      if [[ ! -f /etc/profile.d/nix.sh && -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      fi

      # Load in any kube configs
      set -o null_glob
      KUBE_CONFIGS=(~/.kube/*.config)
      set +o null_glob
      if [[ -n "''${KUBE_CONFIGS}" ]]; then
        export KUBECONFIG="''${(j.:.)KUBE_CONFIGS}"
      fi

    '';
  };

  #programs.neovim = {
  #  enable = true;
  #  plugins = with pkgs.vimPlugins; [
  #    nvim-lspconfig
  #    completion-nvim
  #    galaxyline-nvim
  #    telescope-nvim
  #  ];
  #};

  programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
        nerdtree
        nerdtree-git-plugin
        fzfWrapper
        fzf-vim
        vim-terraform
        vim-orgmode
        vim-speeddating
        utl-vim
        vim-lsp
        async-vim
        asyncomplete-vim
      ];
      extraConfig = ''
        set number
        set linebreak
        set showbreak=+++
        set textwidth=100
        set showmatch
        set visualbell
        set so=7

        if has ("autocmd")
          filetype plugin indent on
        endif

        set autoindent
        set expandtab
        set shiftwidth=4
        set smartindent
        set smarttab
        set softtabstop=4
        set ruler
        set undolevels=1000
        set backspace=indent,eol,start

        " orgmode config
        let g:org_indent = 1
        autocmd Filetype org setlocal tabstop=2
        autocmd Filetype org setlocal shiftwidth=2
        autocmd Filetype org setlocal textwidth=0

        " FZF Config
        map <C-p> :FZF<CR>
        map <C-S-p> :Commands<CR>
        let g:fzf_layout = { 'up': '30%' }
      '';
    };
}
