{ lib, ... }:
{
  home.stateVersion = "22.05";
  home.username = "josh";
  home.homeDirectory = lib.mkDefault "/home/josh";
  programs.home-manager.enable = true;
}
