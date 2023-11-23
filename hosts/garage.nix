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
    ../home-manager/dev-tools.nix
    ../home-manager/xorg.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
    ../home-manager/rbw.nix
    ../home-manager/neovim.nix
    ../home-manager/sublime-text.nix
    ../home-manager/obsidian.nix
  ];

  networking.hostName = "garage";

}
