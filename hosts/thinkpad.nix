{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchGit {
    url = "https://github.com/NixOS/nixos-hardware.git";
  };
in {
  imports = [
    "${nixos-hardware}/lenovo/thinkpad/x1/7th-gen"
    ../common/base.nix
    ../common/efi-boot.nix
    ../common/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/shell-environment.nix
    ../home-manager/dev-tools.nix
  ];

  powerManagement.enable = true;

  networking = {
    hostName = "aether";
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  hardware = {
    brillo.enable = true; # brightness controls
    bluetooth.enable = true;
  };

  sound.enable = true;

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  services = {
    fwupd.enable = true; # firmware updater
    fprintd.enable = true; # fingerprint reader
    blueman.enable = true; # bluetooth
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudio
    usbutils
    # move these to home-manager
    gnupg
  ];

}
