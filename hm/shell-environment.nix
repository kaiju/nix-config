{ config, pkgs, ... }:

{

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    bitwarden-cli
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop.enable = true;
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
      container = {
        disabled = true;
      };
      hostname = {
        style = "bold fg:16 bg:70";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "josh@mast.zone";
    userName = "Josh";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "${pkgs.eza}/bin/eza -gF";
    };

    initExtra = ''

      # FUCK you
      setopt no_prompt_cr

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

      export PATH="$PATH:$HOME/.local/bin"

    '';
  };

}
