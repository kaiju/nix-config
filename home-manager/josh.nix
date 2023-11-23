# This only gets imported from homeConfigurations flake outputs
# and we probably don't actually need it.
{ lib, ... }:
{
  home.stateVersion = "22.05";

  home.username = "josh";

  home.homeDirectory = lib.mkDefault "/home/josh";

  # have home-manager manage home-manager -- this shouldn't matter w/ nixos
  # managed configs?
  programs.home-manager.enable = true;
}
