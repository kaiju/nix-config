{ config, pkgs, ... }:
{
  imports = [
    ../modules/server.nix
    ../modules/user-josh.nix
  ];

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      eth0.useDHCP = true;
    };
    hostName = "artemis";
  };

}
