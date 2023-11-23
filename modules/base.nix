/*
  Profile: base

  This profile is common and applied to all NixOS configurations
*/
{ config, pkgs, ... }:
{

  system.stateVersion = "22.05"; # NixOS 22.05

  users.groups.mast = {
    gid = 1002;
  };

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
    xxd
    tmux
    htop
    ranger
    unzip
    p7zip
    wget
    curl
    git
    file
    lm_sensors
    dnsutils
    usbutils
    nix-tree
    nfs-utils
    hwinfo
    pciutils
  ];

  programs.zsh.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

}
