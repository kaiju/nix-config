{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/xorg.nix
    ../roles/containers.nix
    ../roles/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/ssh-config.nix
    ../home-manager/xorg.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
    ../home-manager/rbw.nix
    ../home-manager/neovim.nix
    ../home-manager/sublime-text.nix
    ../home-manager/obsidian.nix
  ];

  networking.hostName = "garage";
  system.stateVersion = "22.05";

  # sloppy
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

}
