{ config, pkgs, ... }:

{

  home.username = "josh";
  home.homeDirectory = "/home/josh";
  home.stateVersion = "20.09";
  home.sessionVariables = {
    NIX_PATH = ''$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH'';
  };
  
  # Allow home-manager self management
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}



