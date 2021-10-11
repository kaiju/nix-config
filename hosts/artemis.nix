{ config, pkgs, ... }:
{
  imports = [
    ../common/base.nix
    ../common/efi-boot.nix
    ../common/server.nix
    ../josh.nix
  ];

  networking = {
    useDHCP = false;
    interfaces = {
      ens3.useDHCP = true;
    };
    hostName = "artemis";
  };

}
