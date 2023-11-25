{ lib, config, pkgs, ... }:
{

  nix.settings.trusted-users = [ "josh" ];

  users.users.josh = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "mast" "users" "wheel" "networkmanager" "docker" "video" "plugdev" "audio" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADwZpb0PKtHjAPMMTLTPfS1R1pfpCXSaVllJqM5Y9E8 josh@mast.zone"
    ];
  };

  home-manager.users.josh = {

    imports = [
      ../home-manager/shell-environment.nix
      ../home-manager/neovim.nix
    ];

    home.username = "josh";
    home.homeDirectory = "/home/josh";
    home.stateVersion = config.system.stateVersion;

    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/chrome" = "firefox.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
        };
      };
    };

    programs.ssh = {
      enable = true;
      extraConfig = ''
        IdentityFile ~/.ssh/josh@mast.zone.key
      '';
      matchBlocks = {
        "mast.zone" = {
          hostname = "mast.zone";
          forwardAgent = true;
        };
        "straylight" = {
          hostname = "straylight.mast.haus";
          forwardAgent = true;
        };
        "daedalus" = {
          hostname = "daedalus.mast.haus";
          forwardAgent = true;
        };
        "sigint" = {
          hostname = "sigint.mast.haus";
          forwardAgent = true;
        };
      };
    };
  };
}
