{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/server.nix
    ../roles/user-josh.nix
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
