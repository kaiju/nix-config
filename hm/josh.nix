/*
  Common home configuration for Josh across all hosts.
  This gets included in both nixosSystem & homeManagerConfiguration contexts.
*/
{ lib, pkgs, ... }:
{

  imports = [
    ./shell-environment.nix
    ./neovim.nix
  ];

  home.username = "josh";
  home.stateVersion = lib.mkDefault "22.05";
  home.homeDirectory = lib.mkDefault "/home/josh";

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "*" = {
        identityFile = [
          "~/.ssh/josh@mast.zone.key"
        ];
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

  # Make sure I have all my utils
  home.packages = with pkgs.mastpkgs; [
    bootstrap
  ];

}
