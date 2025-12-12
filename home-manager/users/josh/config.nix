/*
  Common home configuration for Josh across all hosts.
  This gets included in both nixosSystem & homeManagerConfiguration contexts.
*/
{ lib, pkgs, ... }:
{

  imports = [
    ../../shell-environment.nix
    ../../neovim.nix
  ];

  home.username = "josh";
  home.stateVersion = lib.mkDefault "22.05";
  home.homeDirectory = lib.mkDefault "/home/josh";

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identityFile = [
          "~/.ssh/josh@mast.zone.key"
        ];
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
      };
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

  programs.git.settings.user = {
    email = "josh@mast.zone";
    name = "josh";
  };

}
