{ config, pkgs, ... }:
{
  imports = [
    ../common/base.nix
    ../common/efi-boot.nix
    ../common/server.nix
    ../common/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/shell-environment.nix
    ../home-manager/dev-tools.nix
  ];

  networking = {
    useDHCP = false;
    interfaces = {
      ens3.useDHCP = true;
    };
    hostName = "artemis";
  };

}
