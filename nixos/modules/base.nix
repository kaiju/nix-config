/*
  Profile: base

  This profile is common and applied to all NixOS configurations
*/
{ pkgs, ... }:
{

  image.modules = {
    lxc-incus = ./lxc-incus.nix;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" # sublime text
    "olm-3.2.16" # nheko
  ];

  system.stateVersion = "22.05";

  networking.nftables.enable = true;

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
    btop
    unzip
    p7zip
    wget
    curl
    jq
    yq
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
    iperf
    pv
  ];

  programs.zsh.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

}
