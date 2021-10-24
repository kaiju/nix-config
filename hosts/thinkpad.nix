{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchGit {
    url = "https://github.com/NixOS/nixos-hardware.git";
  };
in {
  imports = [
    "${nixos-hardware}/lenovo/thinkpad/x1/7th-gen"
    ../roles/base.nix
    ../roles/efi-boot.nix
    ../roles/bluetooth.nix
    #../roles/fonts.nix
    ../roles/sdr.nix
    ../roles/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/ssh-config.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
  ];

  powerManagement.enable = true;
  hardware.opengl.enable = true;

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
  };

  sound.enable = true;

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  services = {
    fwupd.enable = true; # firmware updater
    fprintd.enable = true; # fingerprint reader
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
  ];

}
