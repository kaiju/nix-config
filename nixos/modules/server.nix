{ config, pkgs, ... }:
{

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than +3";
  };

  services = {
    openssh.enable = true;
    prometheus.exporters = {
      node = {
        enable = true;
        openFirewall = true;
      };
    };
  };

  security.pam.sshAgentAuth = {
    enable = true;
  };

}
