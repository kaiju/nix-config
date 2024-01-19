{ config, pkgs, ... }:
{

  networking = {
    useDHCP = true;
    hostName = "artemis";
    domain = "mast.haus";
    firewall.trustedInterfaces = [
      "eth0"
    ];
  };

}
