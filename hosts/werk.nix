{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/efi-boot.nix
    ../roles/vmware-guest.nix
    ../roles/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/neovim.nix
    ../home-manager/ssh-config.nix
    ../home-manager/xorg.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
  ];

  powerManagement.enable = true;
  hardware.opengl.enable = true;

  networking = {
    hostName = "werk";
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      ens33.useDHCP = true;
    };
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  services = {
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
    usbutils
  ];

}
