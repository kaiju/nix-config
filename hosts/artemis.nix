{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/efi-boot.nix
    ../roles/server.nix
    ../roles/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/shell-environment.nix
  ];

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      ens3.useDHCP = true;
    };
    hostName = "artemis";
  };

}
