{ config, pkgs, ... }:
{

  services = {
    openssh.enable = true;
    prometheus.exporters = {
      node = {
        enable = true;
        openFirewall = true;
      };
    };
  };

}
