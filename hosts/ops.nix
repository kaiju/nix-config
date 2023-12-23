{ config, pkgs, ... }:
{

  networking = {
    hostName = "ops";
    useDHCP = false;
    defaultGateway = {
      address = "192.168.8.1";
      interface = "eth0";
    };
    nameservers = [
      "192.168.8.1"
    ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "192.168.8.4"; prefixLength = 22; }
        ];
      };
    };
  };

  services.openssh.ports = [2222];

  services.gitea = {
    enable = true;
  };

}
