{ config, pkgs, ... }:
{
  imports = [
    ../modules/base.nix
    ../modules/xorg.nix
    ../modules/containers.nix
    ../modules/audio.nix
    ../modules/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../../hm/dev-tools.nix
    ../../hm/xorg.nix
    ../../hm/gui-environment.nix
    ../../hm/gnupg.nix
    ../../hm/rbw.nix
    ../../hm/neovim.nix
    ../../hm/sublime-text.nix
    ../../hm/obsidian.nix
  ];

  networking.hostName = "garage";

}
