/*
  Profile: base

  This profile is common and applied to all NixOS configurations
*/
{ config, pkgs, ... }:
{

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" # sublime text
    #"electron-25.9.0"
    "olm-3.2.16" # nheko
  ];

  system.stateVersion = "22.05";

  users.groups.mast = {
    gid = 1002;
  };

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  time.timeZone = "America/New_York";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    download-buffer-size = 524288000
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
    cifs-utils
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
