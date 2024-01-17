{ config, pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;

    /*
    extensions = with pkgs.vscode-extensions; [
      golang.go
      bbenoist.nix
      vscodevim.vim
      redhat.vscode-yaml
    ];
    */

    userSettings = {
    };

  };
}
