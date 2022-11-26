/* This module represents basic configuration common across all systems. */
{ config, pkgs, ... }:
{

  system.stateVersion = "22.05"; # NixOS 22.05

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
  security.pam.enableSSHAgentAuth = true;

  time.timeZone = "America/New_York";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    exa
    tmux
    htop
    ranger
    wget
    curl
    git
    file
    lm_sensors
    dnsutils
    usbutils
    nix-tree
  ];

  programs.zsh.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  /*
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  */

}
